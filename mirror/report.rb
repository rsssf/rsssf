

###
#  to run use:
#
#   $ ruby mirror/report.rb


require_relative 'mirror'


MirrorDb.open


buf = String.new
buf << "#{MirrorDb::Model::Page.count} page(s) " +
         "(#{MirrorDb::Model::Page.cached.count} cached, " +
         "#{MirrorDb::Model::Page.not_cached.count} missing)"
buf << "\n"
buf << "  #{MirrorDb::Model::Link.count} links(s)"
buf << "\n\n"


puts buf



###
## get directory html stats
##
def build

  counters = {
     pages_html:      0,
     pages_html_404:  0,
     pages_pdf:       0,
     pages_other:     0,
  }

  ## directory (file) counters
  dirs = Hash.new(0)
  ## dirs['/'] = 0     ## note - make top-level (root) go first!!


  ## note - use COLLATE NOCASE ASC - for case-insensitive ordering
  MirrorDb::Model::Page.order( 'dirname COLLATE NOCASE ASC',
                               'extname COLLATE NOCASE ASC',
                               'basename COLLATE NOCASE ASC' ).each_with_index do |page,i|

     if page.http_status == 404
        counters[:pages_html_404] += 1
     elsif page.extname == '.html' || page.extname == '.htm'
        counters[:pages_html]  += 1

        basename = File.basename( page.path, File.extname( page.path))
        extname  = File.extname( page.path )
        dirname  = File.dirname( page.path )

        dirs[dirname] += 1
     elsif page.extname == '.pdf'
        counters[:pages_pdf]  += 1
     else   ## other
        counters[:pages_other] += 1
     end

      print "." if i % 100 == 0
  end
  print "\n"

  [dirs,counters]
end



dirs, counters = build()
pp dirs

buf << "%5d page(s) - .html/.htm\n"                 %  counters[:pages_html]


## add dirs
dirs.each do |dir, count|
  buf << "      %-22s  %4d pages(s)" % [dir,count]
  buf << "\n"
end
buf << "\n"
buf << "%5d page(s) - .html/.htm 404 (not found)\n" %  counters[:pages_html_404]
buf << "%5d page(s) - .pdf\n"                       %  counters[:pages_pdf]
buf << "%5d page(s) - other\n"                      %  counters[:pages_other]
buf << "\n"


## add header
text =<<TXT
# RSSSF Mirror Summary / Statistics

```
#{buf}
```


TXT



write_text( "./mirror/SUMMARY.md", text)



puts "bye"
