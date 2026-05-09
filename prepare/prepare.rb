############
#  to run use:
#   $ ruby prepare/prepare.rb   dataset e.g. at/worldcup/etc.


$LOAD_PATH.unshift( './rsssf/lib' )
require 'rsssf'


Webcache.root = './cache'
## Webcache.root = '/sports/cache'   ## use "global" (shared) cache




##
# step 1 - download all world cup "full" pages


 args = ARGV

 opts = {
   force:   false,
   update:  false,
   online:  true,   ## online | offline/cached
   year:    [],
}




  parser = OptionParser.new do |parser|
    parser.banner = "Usage: #{$PROGRAM_NAME} [options] <config slug>"

     parser.on( "-u", "--update",
                 "turn on update; write to production repo (default: #{opts[:update]})" ) do |update|
       opts[:update] = true
     end
     parser.on( "--force",
                 "force download; do NOT use cached version if available (default: #{opts[:force]})" ) do |force|
       opts[:force] = true
     end
     parser.on( "--offline", "--cached",
                 "no downloads; always use cached version (default: #{!opts[:online]})" ) do |offline|
       opts[:online] = false
     end
     parser.on( "--year YEAR,YEAR,YEAR", Array,
                  "turn on filter; include only years specified (default: #{opts[:year]})") do |list|
       ## better use Season() - why? why not?
       opts[:year] += list
     end
  end



  parser.parse!( args )

if args.size == 0
  puts "error: argument required e.g. worldcup, at, etc."
  exit 1
end

puts "OPTS:"
pp opts



code = args.shift  ## get first argument


outdir =   if opts[:update]
              "../tables"
           else
              "./tmp-tables"
           end



pages = read_csv( "./config/#{code}.csv" )
pp pages
puts "  #{pages.size} page(s)"



year = opts[:year]
if year.size > 0     ## check and apply filter by year

  puts "  apply year filter #{year.inspect}"
  pages = Rsssf::Prep.filter_pages( pages, year: year )
  puts "  #{pages.size} page(s)"
end





###########
## pass 1 - download

if opts[:online]
  Rsssf::Prep.download_pages( pages, force: opts[:force]  )
end

##################
## pass 2 - convert

Rsssf::Prep.convert_pages( pages, outdir: outdir )


puts "  #{pages.size} page(s)"

puts "bye"
