
###
#  to run use:
#
#   $ ruby mirror/query_enc.rb


require_relative 'mirror'


MirrorDb.open


puts " #{MirrorDb::Model::Page.count} page(s) " +
         "(#{MirrorDb::Model::Page.cached.count} cached, " +
         "#{MirrorDb::Model::Page.not_cached.count} missing)"

puts "  #{MirrorDb::Model::Link.count} links(s)"


tables_count =   MirrorDb::Model::Page.where( cached: false ).
                                           where( 'path LIKE ?', '/table%' ).count

puts "  #{tables_count} (/table%) page(s)"


fixpath_count =  MirrorDb::Model::Page.where( cached: false ).
                                           where( 'path LIKE ?', '%//%' ).count

puts "  #{fixpath_count}  page(s) w/ //"


fixpath2_count =  MirrorDb::Model::Page.where( cached: false ).
                                           where( 'path LIKE ?', '%/' ).count

puts "  #{fixpath2_count}  page(s) ending with-/"

fixpath3_count =  MirrorDb::Model::Page.where( cached: false ).
                                           where( 'path LIKE ?', '%..%' ).count



puts "  #{fixpath3_count}  page(s) w/ .."


##  typos !!!  e.g. ..m  => ??
##                  ..sources => ../sources
##  2  page(s) w/ ..
## ///miscellaneous/..m/tablesm/madridtops.html             /   1
##                                              <= ///miscellaneous/torre-madrid.html    >Official International Matches of Real Madrid since 1955<
## ///tablesp/..sources.html
##          <= ///tablesp/para43.html    >Paraguay 1943<

MirrorDb::Model::Page.where( cached: false ).
                                           where( 'path LIKE ?', '%..%' ).each do |page|
   dump_page( page, backlinks: true )
end


puts "//:"
MirrorDb::Model::Page.where( cached: false ).
                                           where( 'path LIKE ?', '//%' ).each do |page|
   dump_page( page, backlinks: true )
end

puts "bye"
