
###
#  to run use:
#
#   $ ruby mirror/export_enc.rb


require_relative 'mirror'


MirrorDb.open


puts " #{MirrorDb::Model::Page.count} page(s) " +
         "(#{MirrorDb::Model::Page.cached.count} cached, " +
         "#{MirrorDb::Model::Page.not_cached.count} missing)"

puts "  #{MirrorDb::Model::Link.count} links(s)"


### check for pages with charsets
pages_charset = MirrorDb::Model::Page.where( 'html_charset NOT NULL')
puts "  #{pages_charset.count} page(s) w/ charset"
#=>    2837 page(s) w/ charset
##   iso-8859-1, iso-8859-2, ISO-8859-5, iso-8859-9
##   windows-1250,  windows-1252
##    UTF-8, UTF-16LE


rows = []
pages_charset.order( 'html_charset COLLATE NOCASE ASC',
                     'path' ).each do |page|

    next if page.html_charset.downcase == 'windows-1252'

    rows << [page.html_charset, page.path, page.title ? page.title : '-']
end



headers = ['encoding', 'path', 'title']

write_csv( "./config/encoding.csv", rows, headers: headers )


puts "bye"
