module Rsssf
class Page


###
#  (experimental)
#  machinery to split document by leagues & cups


##
## for now simply split
##    on headings

## let's you check optional ref e.g. ‹§fin›
###  todo/fix - change to OPT_REF_RE   - make it regex
##     regex embedded in regex will use  regex.source automatic (no need to escape)!!
OPT_REF = %q{
            (?: [ ]*
              ‹§ (?<ref> [^›]+?) ›
            )?
         }


###  fix - support match with trailing ==== too!!!

### note - starts at
HEADER_RE = %r{          ## negative lookahead
                     ##   do NOT match  =-=
                     ##   do NOT match  ===========  (without any heading text!!)
                     ##     e.g.
                     ##       Fall season
                     ##       ===========

                    (?! ^[ ]* (?:    =-=
                                 |  ={1,} [ ]* $
                               )
                     )

                     ^
                    [ ]*
                  (?<marker> ={1,6})
                     [ ]*
                  (?<text> .+?)
                     #{OPT_REF}
                     [ ]*
            $}x




def _split_sections( txt, level: 2 )

  sections = {}
  current  = nil

  txt.each_line do |line|
    if m=HEADER_RE.match( line )
        header_level  = m[:marker].size
        header_text   = m[:text]
        if header_level == level
           current = String.new
           sections[ header_text ] = current
           next
        end
    end

    current << line    if current
  end

  sections
end





## make header required - yes
##   change to build_schedule - why? why not???
##    add level: 2 or such - why? why not?
def find_schedule!( header: )
    _find_schedule( header: header, strict: true )
end


def _find_schedule( header:, strict: false )
    ## make sure header is an array
    header = [header]    if header.is_a?( String )

    txt = _walk_sections( @txt, header: header,
                                depth:  0,
                                strict: strict )

    if txt
        ## wrap in schedule class - why? why not?
        schedule = Schedule.new( txt )
        schedule
    else
       nil
    end
end


def _walk_sections( txt, header:,
                         depth:,
                         strict: false )

   query      =  header[depth]
   query_next =  header[depth+1]

   ## note - start at level 2
   sections = _split_sections( txt, level: depth+2 )

   txt = sections[ query ]
   if txt
       if query_next
         txt = _walk_sections( txt, header: header,
                                    depth: depth+1,
                                    strict: strict )
         txt
       else
         txt
       end
   else
      if strict
        ## note - return nil if not found!!!
        raise ArgumentError, "section with header >#{query}< not found; sections incl. #{sections.keys}"
      else
        nil
      end
   end
end  # method _find_schedule



end # class Page
end # module Rsssf