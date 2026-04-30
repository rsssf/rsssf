###
#  to run use:
#
#   $ ruby mirror/gendir.rb   [DIRNAME]
#   $ ruby mirror/gendir.rb   /
#   $ ruby mirror/gendir.rb   /tableso




require_relative 'mirror'


MirrorDb.open


puts
puts "#{MirrorDb::Model::Page.count} page(s) " +
         "(#{MirrorDb::Model::Page.cached.count} cached, " +
         "#{MirrorDb::Model::Page.not_cached.count} missing)"
puts "  #{MirrorDb::Model::Link.count} links(s)"



def build( dirname )
   buf = String.new

   ## note - exclude 404 pages not found!!!
   pages = MirrorDb::Model::Page.where( dirname: dirname,
                                        http_status: nil )

  buf  << "#{pages.count} page(s) .html/.htm found \n\n"

    pages.order( 'basename COLLATE NOCASE ASC' ).each do |page|

      buf << "[`#{page.basename}#{page.extname}`](https://rsssf.org/#{page.path})"
      buf << "  %d/%-d"  % [page.linked_pages.count, page.backlink_pages.count]
      buf << "  %s" % page.title    if page.title
      buf << " <BR>"
      buf << "\n"
   end

   buf << "\n"
   buf
end



args = ARGV
dirname =    args[0] || '/'



buf = build( dirname )
puts buf


header =<<TXT
# Pages in `#{dirname}`

TXT

outpath =   if dirname == '/'
            "./mirror/PAGES_HTML_HOME.md"
          else
            "./mirror/PAGES_HTML_#{dirname[1..-1].upcase}.md"
          end

write_text( outpath, header+buf )


puts "bye"
