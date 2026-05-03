####
#  to run use:
#    $ ruby fmtfix/fmtfix.rb
#
#  e.g.
#   ruby fmtfix\fmtfix.rb oost2026.txt oost00.txt oost2020.txt oost2021.txt oost2022.txt
#   ruby fmtfix\fmtfix.rb span2011.txt span2025.txt

## - try to autofix (convert) the formatting
##     to match the football.txt format


require 'cocos'

require_relative 'fmtfix/_cocos_'


def config_dir
   root_dir = File.expand_path( File.dirname(__FILE__))
   "#{root_dir}/config"
end





require_relative 'fmtfix/rounds'
require_relative 'fmtfix/dates_helpers'
require_relative 'fmtfix/dates'
require_relative 'fmtfix/headers'


require_relative 'fmtfix/base'
require_relative 'fmtfix/errata'
require_relative 'fmtfix/score'
require_relative 'fmtfix/goals'
require_relative 'fmtfix/topscorers'
require_relative 'fmtfix/tables'
require_relative 'fmtfix/about'
require_relative 'fmtfix/outline'







HTML_COMMENT_HEADER_RE = %r{  \A
                            [ \n]*  ## trailing spaces and blank lines
                       <!--
                            [ \n]*
                          (?<text> .+?)
                            [ \n]*
                        -->
                   }imx


###
##   find meta data block (via html-style comment header )
##    incl.   title, autor(s), url,  updated
##  e.g.
##    <!--
##       title:   Austria 2024/25
##       source:  https://rsssf.org/tableso/oost2025.html
##       author:  Hans Schöggl
##       updated: 7 Jul 2025
##      -->
##  -or-
##      authors: Hans Schöggl and Karel Stokkermans

def _parse_meta( txt )
     meta = {}
     m = HTML_COMMENT_HEADER_RE.match( txt )
     if m
        text = m[:text]
        text.each_line do |line|
            line = line.strip

            ## note - allow "inline" blank lines and comment lines (starting w/ #)
            next if line.empty?  || line.start_with?('#')

            ## split line on first colon (:) (only)
            ##   note - limit split to two pieces!!!
            key, value = line.split( /[ ]*:[ ]*/, 2)
            ## use a symbol (not string) as key - why? why not?
            meta[ key.to_sym ] = value
        end
        meta
     else
        nil ## no meta data (comment header) found
     end
end







def fmtfix( filename, outdir: )
        txt = read_text( filename )

        dirname  = File.dirname( filename )
        basename = File.basename( filename, File.extname( filename ) )
        extname  = File.extname( filename )

        ## change outfile  - add .autofix
        outfile = File.join(  outdir, "#{basename}#{extname}" )

        newtxt = autofix( txt )


        ## get title ??
        ##  todo find someething better to get title?
        meta = _parse_meta( newtxt )
        title = meta[:title] || 'n/a'

        newtxt = autofix_outline( newtxt, title: title )

=begin
        ##
        ## add (quick) outline
        outline = build_outline( newtxt )

        ## add inside  <!-- source: ...  [auto-add here] -->
        ## e.g.
        ##   <!--
        ##      source: https://rsssf.org/tableso/oost98.html
        ##    -->

        newtxt = newtxt.sub( %r{^[ ]*<!--
                       [ \n]*
                         (source: .+?)
                        [ \n]*
                      -->
                   }ix,
               "<!--\n  \\1\n\n#{outline} -->" )
=end

        write_text( outfile, newtxt )
end





def main( args,
             path: ['.'],
             update: false
              )

   args.each_with_index do |name,i|

      if File.extname(name).downcase == '.txt'
        puts "==> #{i+1}/#{args.size} #{name}..."

        filename = find_file( name, path: path )

        outdir = './tmp-fmtfix'
        fmtfix( filename, outdir: outdir )
      else
        ## use config
        ##  todo/fix - add a switch -c/--config or such
        ##     or better -f/--filename - why? why not?
        ##    and pass in    at.csv !!

         datafile = "./config/#{name}.csv"
         rows = read_csv( datafile )
         rows.each_with_index do |config,i|

            puts "==> #{i+1}/#{rows.size} #{config.pretty_inspect}..."

            page = config['page']
            dirname  = File.dirname( page )
            basename = File.basename( page, File.extname( page ) )
            extname  = File.extname( page )

            inname = "#{dirname}/#{basename}.txt"
            filename = find_file( inname, path: path )


            outdir = if update
                          ## check for dedicated repos
                          ##  otherwise use ../world/pages
                         if name == 'de'
                            '../clubs/germany/pages'
                         elsif name == 'eng'
                            '../clubs/england/pages'
                         elsif name == 'es'
                            '../clubs/spain/pages'
                         elsif name == 'it'
                            '../clubs/italy/pages'
                         elsif name == 'at'
                            '../clubs/austria/pages'
                         elsif name == 'br'
                            '../clubs/brazil/pages'
                         elsif name == 'mx'
                            '../clubs/mexico/pages'
                         elsif name == 'us'
                            '../clubs/usa/pages'
                         elsif name == 'worldcup' ||
                               name == 'worldcup_full' ||
                               name == 'worldcup_quali'
                            '../worldcup/pages'
                         else
                            '../world/pages'
                         end
                     else
                        ## e.g. ./tmp-eng, ./temp-worldcup etc.
                        "./tmp-#{name}"
                     end

            fmtfix( filename, outdir: outdir )
         end
      end
   end
end





if __FILE__ == $0


  PATH = [
     '../tables',
     '../tables/tableso',
     '../tables/tabless',
     '../tables/tablesd',
     '../tables/tablese',
  ]

  args = ARGV

  opts = { update:  false,
         }

  parser = OptionParser.new do |parser|
    parser.banner = "Usage: #{$PROGRAM_NAME} [options] <.txt files> or <config slugs>"

     parser.on( "-u", "--update",
                 "turn on update; write to production repo (default: #{opts[:update]})" ) do |update|
       opts[:update] = true
     end
  end


  parser.parse!( args )



  main( args,
          path:   PATH,
          update: opts[:update] )


  puts "bye"

end
