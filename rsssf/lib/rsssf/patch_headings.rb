require 'cocos'



## e.g. 2008/09
##   note: also support 1999/2000
## note: use single quotes - quotes do NOT get escaped (e.g. '\d' => "\\d")
##
## SEASON  =   \d{4}/(?:\d{2}|\d{4})
##  built-in for now


def mkheading_regex( str )

    str = str.strip
    ##
    ## change all spaces (other than [ ] and $$ ) to interpunkt
    str = str.gsub( %r{
                             (?<charclass> [ ]* \[ [^\[\]]+ \] [*?+]? [ ]*)
                          |  (?<newline>   [ ]* \$\$ [ ]*)
                          |  (?<spaces>    [ ]+)
                        }x
                       ) do
              m = Regexp.last_match
              if m[:spaces]
                 ' [ ] '     ##  change space to [ ]
              elsif m[:newline]
                 ' \s+ '     ##  $$ => \s+  -- note - make sure \s incl. newline!!
              else
                 m[0]         ## keep as is
              end
            end

  ##  escpape  .   to \.
  ##  change  ~    to [ ]?  -- that is, optional space
  ##  change  ( )  to \( \)
   str = str.gsub(  '~', ' [ ]? ' )
   str = str.gsub(  '.', '\.' )
   str = str.gsub(  '(', '\(' )
   str = str.gsub(  ')', '\)' )


  ### last step change builtins
  ##     '$SEASON$' => '\d{4}/(?:\d{2}|\d{4})',
   str = str.gsub( '$SEASON$', '\d{4}/(?:\d{2}|\d{4})' )

end



def parse_heading_patches( txt )
   patches = {}

   header = nil

   txt.each_line do |line|

      line = line.strip
      next  if line.empty? || line.start_with?('#')
      break if line == '__END__'

      ## check if heading
      if m=%r{ ^
              [ ]* =+ [ ]*
                (?<text> .+?)
              (?: [ ]* =+ )?
               [ ]*
                $
              }x.match(line)

          header = patches[m[:text]] = []
      else
          re =  mkheading_regex( line )
          ## note - wrap in %r{^$}ix
          header <<  %r{^ #{re} $}ix
      end


   end
   patches
end


def read_heading_patches( path )  parse_heading_patches( read_text( path)); end




def _patch_heading( txt, rxs, title )
   found_match = false
   rxs.each do |rx|
     txt = txt.sub( rx ) do |match|
               puts "  found heading match >#{match}< replace with >== #{title}<"

               if title == '*'    ## use orginal title/ do NOT replace/normalize
                  ## note - keep going with replacements here
                  "== #{match}\n"
               else
                  ## note - only short-circuit match if NOT generic replace
                  found_match = true
                  "== #{title}\n"
               end
             end
     ## note - break on first match
     break if found_match
   end
   txt
end


def patch_headings( txt, patches )

     patches.each do |title, rxs|
         txt = _patch_heading( txt, rxs, title )
     end
     txt
end


__END__

patches = read_headings( "./sandbox/de_headings.txt" )
pp patches

txt = read_text( "../clubs/germany/pages/duit09.txt" )
patch_headings( txt, patches )


puts "bye"