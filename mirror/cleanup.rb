
###
#  to run use:
#
#   $ ruby mirror/query_enc.rb


require_relative 'mirror'


MirrorDb.open

puts "before"
puts " #{MirrorDb::Model::Page.count} page(s) " +
         "(#{MirrorDb::Model::Page.cached.count} cached, " +
         "#{MirrorDb::Model::Page.not_cached.count} missing)"

puts "  #{MirrorDb::Model::Link.count} links(s)"


fixpath_count =  MirrorDb::Model::Page.where( 'path LIKE ?', '//%' ).count

puts "  #{fixpath_count}  page(s) w/ //"

MirrorDb::Model::Page.where( 'path LIKE ?', '//%' ).each do |old_page_rec|
   pp old_page_rec
   old_page_rec.outgoing_links.delete
   old_page_rec.incoming_links.delete
   old_page_rec.delete
end



__END__


pp  MirrorDb::Model::Page.where( 'path LIKE ?', '%//%' ).limit(10)




MirrorDb::Model::Page.where( 'path LIKE ?', '%//%' ).each_with_index do |old_page_rec,i|

   if i%10 == 0
     print " #{i+1}"
   end

   path = old_page_rec.path.gsub( %r{/{2,}}, '/' )

   basename = File.basename( File.extname( path ))
   dirname  = File.dirname( path )
   extname  = File.extname( path )

   new_page_rec  =  MirrorDb::Model::Page.find_by( path: path )
   if new_page_rec
       ## update cached to false for new download
       new_page_rec.update!( cached: false )

   else
       ## create a new page rec
      MirrorDb::Model::Page.create!( path: path,
                                     basename: basename,
                                     extname: extname,
                                     dirname: dirname,
                                     encoding: PAGES_ENCODING[ path ],
                                     cached: false )
   end

   old_page_rec.outgoing_links.delete
   old_page_rec.incoming_links.delete
   old_page_rec.delete

   ## old_page_rec.destroy  ## should (auto-incl. dependent links!!
end

print "\n"


puts
puts "after cleanup:"
puts " #{MirrorDb::Model::Page.count} page(s) " +
         "(#{MirrorDb::Model::Page.cached.count} cached, " +
         "#{MirrorDb::Model::Page.not_cached.count} missing)"

puts "  #{MirrorDb::Model::Link.count} links(s)"



puts "bye"

=begin
fix typo:    http.  => http: !!

  path: "/tablesg/http.//www.maltafootball.com"
  path: "/tablest/http.//www.tourism-sport.gov.tm"

=end
