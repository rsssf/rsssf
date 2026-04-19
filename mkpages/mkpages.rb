############
#  to run use:
#   $ ruby mkpages/mkpages.rb 

##
###  generate web site
##      - web pages in .html from .txt



require 'cocos'



require_relative 'mkpages/collect_datafiles'
require_relative 'mkpages/page'
require_relative 'mkpages/toc'     ## table of contents (toc)
require_relative 'mkpages/index'







 args = ARGV

 opts = {
   outdir:     './_site', 
   rootdir:    '../tables',
   index:      false,
   sample:     false,
}



  parser = OptionParser.new do |parser|
    parser.banner = "Usage: #{$PROGRAM_NAME} [options] <dir globs>"

     parser.on( "--outdir DIR", 
                 "output dir(ectory) for generated html pages (default: #{opts[:outdir]})" ) do |outdir|
       opts[:outdir] = outdir
     end
     parser.on( "--rootdir DIR",
                 "root (& working) dir(ectory) for collecting source txt pages (default: #{opts[:rootdir]})" ) do |rootdir|
       opts[:rootdir] = rootdir
     end
     parser.on( "--index",
                 "turn on index page generation (default: #{opts[:index]})" ) do |index|
       opts[:index] = true
     end

     parser.on( "--sample",
                 "for (quick) testing only sample pages (do NOT generate all) (default: #{opts[:sample]})" ) do |sample|
       opts[:sample] = true
     end
  end

  parser.parse!( args )


puts "OPTS:"
pp opts


#####
## default (glob) args - dirs to include (in rootdir)

globs = args.size == 0 ? ['tables', 'tables[a-z]'] : args
           



rootdir = opts[:rootdir]
outdir  = opts[:outdir]


### note - auto-excludes .edits.txt
##           e.g. braz2024.edits.txt.
files = collect_datafiles( *globs, dir: rootdir )
puts "    #{files.size} source .txt file(s) found"



###
### for testing only sample pages (do NOT generate all)
files = [files[0], files[100], files[200], files[300]]   if opts[:sample]



def build_pages( files, dir:, outdir: )
    files.each_with_index do |file,i|
      dirname   = File.dirname( file )
      basename  = File.basename( file, File.extname( file ))

      outpath = "#{outdir}/#{dirname}/#{basename}.html"
      puts "==> [#{i+1}/#{files.size}] building page #{outpath} from (#{file})..."

      path = "#{dir}/#{file}"
      txt = read_text( path )

      html = build_page( txt, file: file )

      write_text( outpath, html )
    end
end


build_pages( files, dir: rootdir,
                         outdir: outdir )

build_index( files, dir: rootdir, 
                         outdir: outdir )   if opts[:index]



puts "bye"





