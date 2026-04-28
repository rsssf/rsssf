
###
#  to run use:
#
#   $ ruby mirror/query.rb


require_relative 'mirror'


MirrorDb.open


puts " #{MirrorDb::Model::Page.count} page(s) " +
         "(#{MirrorDb::Model::Page.cached.count} cached, " +
         "#{MirrorDb::Model::Page.not_cached.count} missing)"

puts "  #{MirrorDb::Model::Link.count} links(s)"



puts "==> missing - 404 not found:"

missing_count = MirrorDb::Model::Page.order( 'path' ).where( http_status: 404 ).count

MirrorDb::Model::Page.order( 'path' ).where( http_status: 404 ).each do |page|
   dump_page( page, backlinks: true )
end



##
##  todo - filter  by  .pdf, .xlsx (excel), .jpg (images),  and rest


not_html_count =  MirrorDb::Model::Page.order( 'path' ).where( 'extname != ?', '.html' ).count
pdf_count      =  MirrorDb::Model::Page.order( 'path' ).where( 'extname == ?', '.pdf' ).count


puts "==> not .html:"
MirrorDb::Model::Page.order( 'path' ).where( 'extname != ?', '.html' ).each do |page|
   dump_page( page, backlinks: true )
end


##
## check if tables left to download ?
tables_count = MirrorDb::Model::Page.where( cached: false ).
                                         where( 'path LIKE ?', '/table%' ).count

puts "  #{tables_count} /tables page(s) to download"



puts "  #{missing_count} page(s) missing - 404 not found"
puts "  #{not_html_count} page(s) w/ != .html"
puts "  #{pdf_count} page(s) w/ .pdf"

##
## typos e.g. .hml => html    or
##            .htm => html
##
##   /tablesj/jpn-wom20234html

# valid media types:
#  .jpg
#  .xlsx, .xlsx

##
##  missing mailto:
##  e.g. /tableso/fivro@setarnet.aw


## anames with missing # e.g.
##    /tablesi/2gruppoa
##    /tablese/52

## TXT!!! e.g.
##  /tablesc/ccodes.txt
##  /tablesd/differs.txt


puts "bye"
