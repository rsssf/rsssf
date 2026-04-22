############
#  to run use:
#   $ ruby mkpages/mkpages.rb

##
###  generate web site
##      - web pages in .html from .txt



require 'cocos'



require_relative 'mkpages/collect_datafiles'

require_relative 'mkpages/build_page'
require_relative 'mkpages/build_index'
require_relative 'mkpages/build_codes'
require_relative 'mkpages/build_updates'
require_relative 'mkpages/build_links'
require_relative 'mkpages/build_site'
require_relative 'mkpages/meta'      ## parse_meta  --in html-style comment header


require_relative 'mkpages/page_toc'     ## table of contents (toc)
require_relative 'mkpages/page_banner'
require_relative 'mkpages/page_layout'   ## aka master page layout/template






 args = ARGV

 opts = {
   outdir:     './_site',
   rootdir:    '../tables',
   index:      true,
   codes:      true,
   updates:    true,
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
     parser.on( "--codes",
                 "turn on codes (index) page generation (default: #{opts[:codes]})" ) do |codes|
       opts[:codes] = true
     end
     parser.on( "--updates", "--latest",
                 "turn on (lastest) updates (index) page generation (default: #{opts[:updates]})" ) do |updates|
       opts[:updates] = true
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
files = [files[0], files[20],
         files[100], files[101],
         files[200], files[201], files[230],
          files[300]]      if opts[:sample]


site = SiteIndex.build( files, dir: rootdir )




def build_pages( site, outdir: )
    ## todo/check - why each_page.with_index is not working??)
    site.each_page_with_index do |page,i|

      outpath = "#{outdir}/#{page.basename}.html"
      puts "==> [#{i+1}/#{site.size}] building page #{outpath} (#{page.dirname}/#{page.basename}.txt)..."

      html = build_page( page )

      write_text( outpath, html )
    end
end



def build_style( outdir: )

  css =<<CSS

a, a:visited {
  text-decoration: none;
}

a:hover {
  text-decoration: underline;
}


/*********
  reset h1,h2,h3,h4,h5,h6 formatting inside pre blocks
  ****/

  pre h1,
  pre h2,
  pre h3,
  pre h4,
  pre h5,
  pre h6 { /* color: red;  */
            font-size: 100%;
            margin: 0;
             }



   pre h1,
   pre h2,
   pre h3 {
      font-size: 150%;
   }

  pre h4 {
     /* add blue-ish background */
     background-color: #CCCCFF;
     padding-top: 1px;
     padding-bottom: 1px;
  }


  pre h5 {
            /* bold by default keep */
         }

 pre h6 {
            font-weight: normal;
            /* use underline */
            text-decoration: underline;
         }

CSS

   write_text( "#{outdir}/style.css", css )
end





build_pages( site, outdir: outdir )

build_index( site, outdir: outdir )   if opts[:index]

build_codes( site, outdir: outdir )   if opts[:codes]

build_updates( site, outdir: outdir )  if opts[:updates]


build_links( site, outdir: outdir )


## write out sitewide stylesheet (style.css)
build_style( outdir: outdir )


puts "bye"
