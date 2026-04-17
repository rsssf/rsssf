
=begin
## let's you check optional ref e.g. ‹§fin›
OPT_REF = %q{
            (?: [ ]*    
              ‹ (?<ref> §[^›]+?) ›
            )?
         }
=end


HEADING1_RE = %r{  ^ [ ]* (?<text> .+?)  #{OPT_REF}  [ ]*   
                              \n
                     [ ]* (?<markers>   ={3,}) [ ]*
                              \n
                  }ix


##  note - eat-up optional marker before text
##  e.g.
##   -----------------
##   TFV CUP 2000/2001
##   -----------------


HEADING2_RE = %r{    ^ 
                           (?: [ ]* -{3,} [ ]* \n )?  
                          [ ]* (?<text> .+?)  #{OPT_REF}  [ ]*   
                               \n
                           [ ]* (?<markers>  -{3,}) [ ]*
                              \n
                  }ix

##
##   OST
##   ___
HEADING2_ALT_RE = %r{    ^  
                          [ ]* (?<text> .+?)  #{OPT_REF}  [ ]*   
                               \n
                           [ ]* (?<markers> _{3,}) [ ]*
                              \n
                  }ix



def _is_heading?( m )
    text    = m[:text]
    markers = m[:markers]
              
               ## note - (i) the size/length MUST match (allow only +/-1)
                 ## next - do NOT allow more than three spaces in
                   ##    to avoid hr lines in tables
                   ##  and limit length to 60 chars for now
               if (text.size == markers.size ||
                   text.size == markers.size+1 ||
                   text.size == markers.size-1) &&
                    text.size <= 60 &&
                    !text.match?( /[ ]{3,}/ )
                     true 
               else
                    false
               end
end



def handle_headings( txt )

## e.g. Fall season
##      ===========
##
##      Spring season:
##      ==============
##
##      PROMOTION AND RELEGATION ISSUES
##      ===============================
##
##   note - allow optional anchor e.g.
##    Tirol  ‹§tirol›
##    =====
##
##    or
##   TIROL
##   *****
##
##  add ****  - why?
##
##  ****************
##  FOHRENBURGER CUP
##  ****************



##
##   Feeder leagues Regionalliga West (tables of fall season):
##   --------------------------------------------------------
##
##   AUSTRIA, Feeder Leagues of the Second Bundesliga and below.
##   -----------------------------------------------------------

##   -----------------
##   TFV CUP 2000/2001
##   -----------------


###
##  note - only replace (convert) headings with ==== for now




   txt = txt.gsub( HEADING1_RE ) do |match|
             m = Regexp.last_match           
               if _is_heading?( m )
                   ## convert to h4 for now 
                   if m[:ref]
                      "==== #{m[:text]} ‹#{m[:ref]}› ====\n" 
                   else 
                      "==== #{m[:text]} ====\n"
                   end                
                else
                    match   ## do not change; keep as is - assume hr rule or such
                end
           end    

=begin
   txt = txt.gsub( HEADING2_RE ) do |match|
             m = Regexp.last_match           
               if _is_heading?( m )
                   if m[:ref]
                      "===== #{m[:text]} ‹#{m[:ref]}› =====\n" 
                   else 
                      "===== #{m[:text]} =====\n"
                   end                
                else
                    match   ## do not change; keep as is - assume hr rule or such
                end
           end    
  
           
 txt = txt.gsub( HEADING2_ALT_RE ) do |match|
             m = Regexp.last_match           
               if _is_heading?( m )
                   if m[:ref]
                      "===== #{m[:text]} ‹#{m[:ref]}› =====\n" 
                   else 
                      "===== #{m[:text]} =====\n"
                   end                
                else
                    match   ## do not change; keep as is - assume hr rule or such
                end
           end    
=end     
   
   
   txt
end