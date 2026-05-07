module Rsssf
class  Prep    ## todo: find a better name e.g. BatchPrep or ??


###
##  remove trailing about document meta backmatter
##  == About this document  ‹§about›
##

##
##  note - start_with anchored w/ \A to start of string

START_WITH_ABOUT_RE = %r{  \A
                  [ \n]*   ## trailing spaces or blank lines
                  ={2,} [ ]* About [ ]+ this [ ]+ document
                   .*?
              }ix

###
##  remove "custom" sections by title
##   e.g.   === Index of groups
START_WITH_CUSTOM_RE = %r{  \A
                  [ \n]*   ## trailing spaces or blank lines
                  ={2,}
                      [ ]*
                        (?<title>
                           Index [ ] of [ ] groups
                         )
                     [ ]*
                   $
              }ix

##
## todo - fix
##
##   remove all menu, ul,li, tags etc.
##    before nav check
##    see https://rsssf.github.io/tables/2014q.html
##       as an example!!!

START_WITH_NAV_RE = %r{  \A
                [ \n]*    ## trailing spaces or blank lines
                ‹.+?›    ##  link  (exlude named anchor - why? why not? §)
             }ix






def postproc_page( txt, basename:, dirname: )

  ### record edits in its own txt file
  edits = []
  links = []
  about = nil


###
##  step 1
##   split by horizontal rules (hrs)
##       and remove navigations sections
##             starting with links e.g.
## ‹Bundesliga, see §bund›

   sects = txt.split( /^=-=-=-=-=-=-=-=-=-=-=-=-=-=-=$/ )




   sects = sects.select do |sect|
             if START_WITH_NAV_RE.match?( sect )
                links += collect_links( sect, basename: basename,
                                              dirname: dirname )

              edit = String.new
               edit += "-- removing nav(igation) section:"
               edit += sect

               puts edit

               edits << edit   ## record edit

               false           ## remove section
             elsif m=START_WITH_CUSTOM_RE.match( sect )
                links += collect_links( sect, basename: basename,
                                              dirname: dirname )

                edit = String.new
                edit += "-- removing custom section with title >#{m[:title]}<:"
                edit += sect

                puts edit

                edits << edit   ## record edit

                false           ## remove section

             elsif START_WITH_ABOUT_RE.match?( sect )
                ## note - do NOT collect links in about section!!!

               about = sect
               false           ## remove (about) section
             else
                links += collect_links( sect, basename: basename,
                                              dirname: dirname )
               true            ## keep section
             end
           end

   ## sects.each_with_index do |sect,i|
   ##  puts "==> #{i+1}/#{sects.size}"
   ##  pp sect
   ## end
   ##  puts "  #{sects.size} sect(s)"


   ## note - replace hr with blank line
   txt = sects.join( "\n\n" )


   ###
   ## remove pre comments
   txt = txt.gsub( "<!-- start pre -->\n", '' )
   txt = txt.gsub( "<!-- end pre -->\n", '' )



    ## try to remove leading and trailing nav(igation) lines
    txt, more_edits = proc_navlines_by_sections( txt )
    edits += more_edits

   ## note - return (new) txt AND recorded edits (& erratas)
   ##        return edits as array or joined (single) string - why? why not?
   ##   note - return empty array if no edits!!
   [txt, edits, links, about]
end


end    ## class Prep
end    ## module Rsssf