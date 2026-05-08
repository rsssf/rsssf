
module Rsssf
class  Fmtfix    ## todo: find a better name e.g. Format or Fixer or ??




## convenience helper
def self.fmtfix( filename, outdir:, heading_patches: nil )
      @@fmtfix ||= new   ## use a "shared" built-in prep
      @@fmtfix.fmtfix( filename, outdir: outdir, heading_patches: heading_patches )
end


##
## todo/fix / fix / fix
##    pass in txt only not filename & outdir!!!

def fmtfix( filename, outdir:, heading_patches: nil )
        txt = read_text( filename )

        dirname  = File.dirname( filename )
        basename = File.basename( filename, File.extname( filename ) )
        extname  = File.extname( filename )

        ## change outfile  - add .autofix
        outfile = File.join(  outdir, "#{basename}#{extname}" )


        ### note - step 1
        ##      autofix-outline
        ##  and patch headings/outline if empty
        ##        with at_headings.txt, de_headings.txt etc.


        ## get title ??
        ##  todo find someething better to get title?
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

        write_text( outfile, newtxt )
end


end    ## class Fmtfix
end    ## module Rsssf
