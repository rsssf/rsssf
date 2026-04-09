require_relative 'helper'


## pretty print (page) outline


## let's you check optional ref e.g. ‹§fin›
OPT_REF = %q{
            (?: [ ]*    
              ‹ (?<ref> §[^›]+?) ›
            )?
         }

##
##  note - do not match horizontal rule (hr)!!!
##     e.g.  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=

HEADING_RE = %r{\A
         [ ]*
          (?! =-= ) ## negative lookahead for horizonat rule!!
                    ##  header cannot start with == !!! 
          (?<level>={1,6})
           [ ]*
            (?<text>.+?)  ## use non-greedy; cannot be empty
   
            #{OPT_REF}
          
             (?: [ ]*   ## optional trailing heading markers 
                 ={1,} 
             )?    
         [ ]* 
\z}ix

##########
## check "free standing" round headers e.g.


## allow optional winner or qualified team in bracket
##   e.g. [West Germany]
##     
## note - uses single-quote ('') string - backslash is backslash

OPT_GROUP_NOTES = %q{
                  (?: 
                        [ ]*
                     \[  [^\]]+  \]                     
                  )?
                 }


##  -- special intercontinental groups
GROUP_INTERCONTI_RE =%r{\A
        [ ]*
         (?<text>
                     (?:   Europe 
                         | South [ ] America 
                         | Central [ ] and [ ] North [ ] America 
                         | North [ ] and [ ] Central [ ] America [ ] and [ ] Paraguay 
                         | North [ ] and [ ] Central [ ] America 
                         | Asia [ ] and [ ] Africa 
                         | Africa [ ] and [ ] Asia 
                         | Asia [ ] and [ ] Oceania [ ]
                         | Africa 
                         | Asia 
                         | [A-Z]+ (?: [ ][A-Z]+)*   ## fix - change to unicode alpha - why? why not? 
                      ) 
                     [ ]
                    Group [ ] \d{1,2}
                    #{OPT_GROUP_NOTES}
         ) 
       [ ]*
\z}ix




GROUP_RE = %r{\A
        [ ]*
         (?<text>
           (?:    Group [ ]
                 (?:   [A-Z]              ## e.g  group a, group b,
                     | \d{1,2}            ##      group 1, group 2,
                     | I | II | III | IV  ##      group i, group ii, etc.
                  )
                 #{OPT_GROUP_NOTES}   
            )
            | (?:  Subgroup [ ] (?: [A-Z] | \d{1,2} ))
            |  Playoff:?         # used inside Group B etc. really Group A/B/C/D Playoff          
         )                        
        [ ]*
\z}ix


ROUND_RE = %r{\A
        [ ]*
         (?<text>
               Round [ ] \d{1,2}     ## e.g. round 1, round 2, etc.
             | (?: First | Second | Third | 1st | 2nd | 3rd) [ ] round 

             | (?: First | Second | 1st | 2nd) [ ] phase 
                         
             | 1/8 [ ] Finals  
             | Eightfinals 

             | Quarter [ -]? finals 
             | Semi [ -]? finals 
             
             | Third [ ] place [ ] match 
             | Match [ ] for [ ] third [ ] place 

             | Final 
             | Final [ ] group | Final [ ] pool 
             | Deciding [ ] match
         )
             #{OPT_REF}
         [ ]*
\z}ix



def outline( txt )

    outline = []
    txt.each_line.with_index do |line, i|
        ## cut-off trailing newline
        ##  use chomp??
        line = line.rstrip
        if m=HEADING_RE.match( line )
             ## break out ref(erence) e.g. a name - why? why not?
             level = m[:level].size  ## note =(1), ==(2), etc.
             text  = m[:text]
             ref   = m[:ref]
             node = [:"h#{level}", text, "@#{i+1}"]
             node << ref  if ref
            
             outline << node
        elsif (m=ROUND_RE.match( line ) ||
               m=GROUP_RE.match(line) ||
               m=GROUP_INTERCONTI_RE.match(line))
               captures = m.named_captures  
               text  = captures['text']
               ref   = captures['ref']
              node = [:"_", text, "@#{i+1}"]
             node << ref  if ref
   
             outline << node       
        end
    end
    outline
end



def ppoutline( glob, workdir: )
   buf = String.new

   Dir.chdir( workdir ) do
     files = Dir.glob( glob )

## sort numeric first by basename!!
##  than by alpha
      files = files.sort do |l,r|
                 lbasename = File.basename(l, File.extname(l))
                 rbasename = File.basename(r, File.extname(r))
                 res = rbasename.to_i(10) <=> lbasename.to_i(10)
                 res = lbasename <=> rbasename              if res == 0
                 res = File.dirname(l) <=> File.dirname(r)  if res == 0
                 res 
               end
  

     buf << "==> #{files.size} file(s) in (#{workdir}) matching #{glob}:\n"
     
     files.each_with_index do |path,i|
        txt = read_text( path )
        puts "[#{i+1}/#{files.size}] #{} - #{path}, #{txt.lines.size} line(s):"
        
        basename = File.basename( path )
        dirname  = File.dirname( path )
        buf << "\n#{basename} (in #{dirname}), #{txt.lines.size} line(s):\n"
        outline = outline( txt )

        outline.each do |el, text, pos, ref|
           buf << "  "
           buf << "%-2s" % el
           buf << "  "
           buf << "#{text}    #{pos}"
           buf << ", #{ref}" if ref
           buf << "\n"
        end
     end
   end
 
   buf
end


## buf = ppoutline( "./pages/**/*q.txt", workdir: '../worldcup')
## buf = ppoutline( "./pages/**/*f.txt", workdir: '../worldcup')
buf = ppoutline( "./pages/**/*full.txt", workdir: '../worldcup')

puts buf
## write_text( "./tmp2/index-q.txt", buf )
## write_text( "./tmp2/index-f.txt", buf )
write_text( "./tmp2/index-full.txt", buf )


puts "bye"


