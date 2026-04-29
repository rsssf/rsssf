###
#  to run use:
#
#   $ ruby mirror/find.rb  TITLE


require_relative 'mirror'


MirrorDb.open


puts " #{MirrorDb::Model::Page.count} page(s) " +
         "(#{MirrorDb::Model::Page.cached.count} cached, " +
         "#{MirrorDb::Model::Page.not_cached.count} missing)"

puts "  #{MirrorDb::Model::Link.count} links(s)"

args = ARGV
if args.size != 1
    puts "!! error - argument required to find pages"
    exit 1
end

query = args[0]


pages = MirrorDb::Model::Page.where('title LIKE ?', "%#{query}%").
                      order( 'dirname COLLATE NOCASE ASC',
                             'extname COLLATE NOCASE ASC',
                             'basename COLLATE NOCASE ASC' )

pages.each do |page|
    dump_page( page )
end


puts "   #{pages.count} page(s) found"
puts "bye"
