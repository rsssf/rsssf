
###
#  to run use:
#
#   $ ruby mirror/query_html.rb


require_relative 'mirror'


MirrorDb.open


puts " #{MirrorDb::Model::Page.count} page(s) " +
         "(#{MirrorDb::Model::Page.cached.count} cached, " +
         "#{MirrorDb::Model::Page.not_cached.count} missing)"

puts "  #{MirrorDb::Model::Link.count} links(s)"


### check for pages with tabs

pages_tabs = MirrorDb::Model::Page.where( 'tabs NOT NULL')
puts "  #{pages_tabs.count} page(s) w/ tabs"
#=>   11946 page(s) w/ tabs  !!!

### check for pages with charsets
pages_charset = MirrorDb::Model::Page.where( 'html_charset NOT NULL')
puts "  #{pages_charset.count} page(s) w/ charset"
#=>    2837 page(s) w/ charset
##   iso-8859-1, iso-8859-2, ISO-8859-5, iso-8859-9
##   windows-1250,  windows-1252
##    UTF-8, UTF-16LE


### check for pages with doctype
pages_doctype = MirrorDb::Model::Page.where( 'html_doctype NOT NULL')
puts "  #{pages_doctype.count} page(s) w/ doctype"
#=>   40547 page(s) w/ doctype



pages_tabs.order( 'path' ).each do |page|
   dump_page( page )
     puts "   #{page.tabs} tab(s)   -- #{page.html_charset} | #{page.html_doctype}"
end



puts "bye"
