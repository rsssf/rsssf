

###
## <b><a name="fall">Opening Season 2024</a></b>  => <hb> ... </hb>
## <u><a name="fplay">Playoff Stage</a></u>       => <hu> ... </hu>
##
##  (inofficial) heading "bold", heading "underscore"
##  note - MUST be one single "stand-alone" line  (in pre block) !!!

=begin
BU_ANAME_LINE_RE = %r{^ [ ]*  < (?<tag>B|U) > 
             [ ]* (?<text>
                     <A [ ]+ NAME
                      .+?
                     </A> 
                   ) 
             [ ]*  </ \k<tag> > 
             [ ]*
        $}ix    
=end


## scan for now only (do NOT replace)
BOLD_OR_UNDERLINE_LINE_RE = %r{^ [ ]*  < (?<tag> [BU]) > 
             [ ]* (?<text>
                      .+?   ## note - use non-greedy match
                   ) 
             [ ]*  </ \k<tag> > 
             [ ]*
        $}ix



def make_heading( html )
  edits = []

  html = html.gsub( BOLD_OR_UNDERLINE_LINE_RE ) do |match|
        m = Regexp.last_match

        tag  = m[:tag].downcase 
        text = m[:text]

        if text.downcase.start_with?( '<a name' )
          msg =  "make heading (h#{tag}) out of #{tag}-enclosed a name in line >#{text}<"
          puts " #{msg}"
      
          ## note - edit line MUST start with --
          ##         might be multi-line
          edits << "-- #{msg}" 
            
          "<h#{tag}>#{text}</h#{tag}>"
        else 
          ## note - skip (false positive) copyright line (in about this document)
          ##  (C) Copyright RSSSF
          ##      Copyright
          if %r{copyright}i.match?( text )
          else
            msg =  "found #{tag}-enclosed line >#{text}< - heading?"
            puts " #{msg}"
      
            edits << "-- #{msg}" 
          end

            match   ## keep as is (do NOT change)
        end     
  end


  [html, edits]
end
