
module Rsssf
class  Fmtfix    ## todo: find a better name e.g. Format or Fixer or ??



## convenience helper
def self.fmtfix_pages( pages, outdir:, path:, heading_patches: nil )
      @@fmtfix ||= new   ## use a "shared" built-in fmtfix
      @@fmtfix.fmtfix_pages( pages, outdir: outdir,
                                    path: path,
                                    heading_patches: heading_patches )
end

def fmtfix_pages( pages, outdir:,
                         path:,         ## (lookup search) path (array expected!!!)
                         heading_patches: nil )

     pages.each_with_index do |config,i|

            puts "==> #{i+1}/#{pages.size} #{config.pretty_inspect}..."

            page = config['page']
            dirname  = File.dirname( page )
            basename = File.basename( page, File.extname( page ) )
            extname  = File.extname( page )

            inname = "#{dirname}/#{basename}.txt"
            filename = find_file!( inname, path: path )

            txt = read_text( filename )
            newtxt = fmtfix( txt, heading_patches: heading_patches )

            outfile = File.join(  outdir, "#{basename}.txt" )
            write_text( outfile, newtxt )
     end
end



## convenience helper
def self.fmtfix( txt, heading_patches: nil )
      @@fmtfix ||= new   ## use a "shared" built-in fmtfix
      @@fmtfix.fmtfix( txt, heading_patches: heading_patches )
end



def fmtfix( txt,  heading_patches: nil )

        ### note - step 1
        ##      autofix-outline
        ##  and patch headings/outline if empty
        ##        with at_headings.txt, de_headings.txt etc.

        ## get title
        meta = Page.parse_meta( txt )
        title = meta[:title] || 'n/a'

        newtxt = autofix_outline( txt, title: title )


        if heading_patches
            ##
            ## check if any headings / outline
             headings = _scan_outline( newtxt )
             if headings.size == 0
                newtxt = patch_headings( newtxt, heading_patches )
             end
        end


        newtxt = autofix( newtxt )



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
         newtxt
end


end    ## class Fmtfix
end    ## module Rsssf
