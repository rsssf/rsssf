module Rsssf
class  Prep    ## todo: find a better name e.g. BatchPrep or ??



=begin

todo - remove all "trailing" nav links in section

‹1974/75, see page oost75›.

‹1976/77, see page oost77›.

‹list of final tables, see page oosthist›.

‹list of champions, see page oostchamp›.

‹list of cup finals, see page oostcuphist›.

‹list of super cup finals, see page oostsupcuphist›.

‹list of foundation dates, see page oostfound›.
=end




def strip_navlines( lines, heading: true )
## note - expects an array of lines (e.g. txt.lines!!!)

          newlines = []
          navlines = []
          body     = false    ## hit/seen body?
          lines.each_with_index do |line,lineno|
              ## check for optional leading heading line
              ## note - first line is heading
              ##  (only optional for first section)
              if heading && lineno == 0 && line.lstrip.start_with?( '==' )
                    newlines << line
                    next
              end

              ##  possibly remove leading nav link lines
              if !body
                 if line.strip.empty?
                    newlines << line
                    next
                 end

                 ## remove leading nav link lines only
                 newline = line.strip.gsub( /‹.+?›/, '' )
                 ##  check what's left over?
                 ##  if only space or pipe (|) or dot (.) than remove
                 if newline.match?( %r{\A
                                        [ |.]*
                                     \z}ix )
                    ## puts "  removing nav line #{line}"
                    navlines << line
                    ## eat-up; record edit
                 else
                    body = true
                    newlines << line
                 end
              else
                  newlines << line
              end
          end  # each line

          [newlines,navlines]
end




def proc_navlines_by_sections( txt )

   edits = []

   ###
   ##  remove  remaing nav html elements
   ##  <MENU></MENU>
   ##   <UL></UL>
   ##   <LI></LI>

      tags = []
     txt = txt.gsub( %r{   <MENU> | </MENU>
                         | <UL>   | </UL>
                         | <LI>   | </LI>
                       }ix ) do |match|
         tags << match
           ''
     end

     if tags.size > 0
                edit = String.new
                edit += "-- removed #{tags.size} remaining nav html element(s):\n"
                edit += tags.join( ' ')

                puts edit

                edits << edit   ## record edit
      end


    sections = txt.split( %r{^
                               (?= [ ]* ={2,} [ ]*
                                    [\p{L}0-9]  ## one letter or digit required
                               )
                            }ix
                        )


     newsections = []
     sections.each_with_index do |sect,sectno|
          newlines, navlines = strip_navlines( sect.lines, heading: true )

          if navlines.size > 0
             edit = String.new
             edit += "-- removing #{navlines.size} leading nav line(s) in section #{sectno+1}:\n"
             edit += navlines.join
             puts edit

             edits << edit
          end


          ## special check for last section
          if sectno+1 == sections.size
              ## reverse lines
              ##  and remove trailing navlines until hitting body
              ##   note - set heading to false
              newlines, navlines = strip_navlines( newlines.reverse, heading: false )
              newlines = newlines.reverse
              navlines = navlines.reverse

              if navlines.size > 0
                edit = String.new
                edit += "-- removing #{navlines.size} trailing nav line(s) in last section #{sectno+1}:\n"
                edit += navlines.join
                puts edit

                edits << edit
              end
          end

          newsections << newlines.join
     end # each section

    [newsections.join, edits]
end


end    ## class Prep
end    ## module Rsssf