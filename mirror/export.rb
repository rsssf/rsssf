

#
## fix
##  /USAdave/alpf.html,1/1,American League of Professional Football
## /USAdave/am-soc-overview-wom.html,1/1,USA - An Overview of American Women's Soccer History
## /USAdave/am-soc-overview.html,2/1,USA - An Overview of American Soccer History
## /USAdave/apsl.html,1/3,USA - A-League (American Professional Soccer League)
## /USAdave/asli.html,2/2,American Soccer League I
## /USAdave/aslii.html,2/4,USA - American Soccer League II

##
##  cache hit on /USAdave !!!
##    check for casesensitive check on windows!!!!!!
##

=begin
add  (2).hml to errata
/tablesv/vasco-trip49.hml,-/1,
/tablesv/vascodagama-mextour49.hml,-/1,


## yes, allow/add .htm  for page !!

/ec/Armenia.htm,-/1,
/ec/Azerbaijan.htm,-/1,
/ec/Belarus.htm,-/1,
/ec/Belgium.htm,-/1,
/ec/Bosnia.htm,-/1,
=end



###
#  to run use:
#
#   $ ruby mirror/export.rb


require_relative 'mirror'


MirrorDb.open


puts " #{MirrorDb::Model::Page.count} page(s) " +
         "(#{MirrorDb::Model::Page.cached.count} cached, " +
         "#{MirrorDb::Model::Page.not_cached.count} missing)"

puts "  #{MirrorDb::Model::Link.count} links(s)"



def build
  rows_html     = []
  rows_html_404 = []
  rows_pdf      = []
  rows_other    = []


  ## note - use COLLATE NOCASE ASC - for case-insensitive ordering
  MirrorDb::Model::Page.order( 'dirname COLLATE NOCASE ASC',
                               'extname COLLATE NOCASE ASC',
                               'basename COLLATE NOCASE ASC' ).each_with_index do |page,i|

      ## note - for now only .html/.htm pages can be 404
      if page.http_status == 404
          rows_html_404 << [page.path,
                             "-/#{page.backlink_pages.count}",
                             '']
      elsif page.extname == '.html' || page.extname == '.htm'
          rows_html     << [page.path,
                           "#{page.linked_pages.count}/#{page.backlink_pages.count}",
                           page.title ? page.title : '-'
                          ]
      elsif page.extname == '.pdf'
          rows_pdf << [page.path,
                             "-/#{page.backlink_pages.count}",
                             '']
      else  ## add (rest) to other
          rows_other << [page.path,
                             "-/#{page.backlink_pages.count}",
                             '']
      end

      print "." if i % 100 == 0
  end
  print "\n"

  [rows_html, rows_html_404, rows_pdf, rows_other]
end




rows_html, rows_html_404, rows_pdf, rows_other = build()



headers = ['path', 'links', 'title' ]

write_csv( "./tmp-mirror/pages_html.csv",     rows_html,     headers: headers )
write_csv( "./tmp-mirror/pages_html_404.csv", rows_html_404, headers: headers )
write_csv( "./tmp-mirror/pages_pdf.csv",      rows_pdf,      headers: headers )
write_csv( "./tmp-mirror/pages_other.csv",    rows_other,    headers: headers )


puts "bye"
