###
#  to run use:
#
#   $ ruby mirror/gen404.rb


require_relative 'mirror'


MirrorDb.open


puts
puts "#{MirrorDb::Model::Page.count} page(s) " +
         "(#{MirrorDb::Model::Page.cached.count} cached, " +
         "#{MirrorDb::Model::Page.not_cached.count} missing)"
puts "  #{MirrorDb::Model::Link.count} links(s)"



def build
   buf = String.new
   pages = MirrorDb::Model::Page.not_found

  buf  << "#{pages.count} .html/.htm page(s) found\n\n"

    pages.order( 'dirname COLLATE NOCASE ASC',
                               'extname COLLATE NOCASE ASC',
                               'basename COLLATE NOCASE ASC' ).each do |page|

  buf << "**`#{page.path}`**"
  buf << " w/ #{page.backlink_pages.count} backlink(s): <br>"
  buf << "\n"
  page.backlink_pages.each_with_index do |backlink,i|
     buf << "\[#{i+1}\] "
     ### note - path ALWAYS starts with slash (/) already e.g. /tables
     buf << "[`#{backlink.path}`](https://rsssf.org#{backlink.path})"
     buf << "  %d/%-d"  % [backlink.linked_pages.count, backlink.backlink_pages.count]
     buf << "  %s" % backlink.title    if backlink.title
     buf << "<br>"
     buf << "\n"
   end
  buf << "\n"
end
  buf
end




buf = build()
puts buf

header =<<TXT
# Pages - 404 Not Found

TXT

write_text( "./mirror/PAGES_HTML_404.md", header+buf )


puts "bye"
