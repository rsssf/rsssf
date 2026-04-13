
## let's you check optional ref e.g. ‹§fin›
OPT_REF = %q{
            (?: [ ]*    
              ‹ (?<ref> §[^›]+?) ›
            )?
         }



###
### note - allow optional colon e.g.
##     Playoff:
##     Round 21:

HEADER_ROUND_RE = %r{\A
        [ ]*
         (?<round> #{ROUND_PAT})
              :?   ## note - allow optional colon (:)  e.g. Playoff:
            #{OPT_REF}
         [ ]*
\z}ix



## date header (w/ brackets)
##   [Aug 7]
##   [Oct 23]
##
###  note - might be date range or date list!!!
##   [Aug 7-9]
##   [Aug 7, 8]



## helper for inline regexes (with union) and escaped
def date_( *re ) 
      raise ArgumentError, "more than one date regex expected, got #{re}"  if re.size < 1      
      
      ## (auto-)wrap in non-capature group - why? why not?
      "(?: #{Regexp.union( *re ).source})"
end


HEADER_DATE_RE = %r{\A
      [ ]*
      \[  #{date_(DATE_I_RE, DATE_IB_RE,
                  DATE_II_RE,
                  DATE_RANGE_RE,
                  DATE_LIST_RE, DATE_LEGS_RE,
                  )}
      \]
      [ ]*
\z}ix

## pp HEADER_DATE_RE
## pp DATE_I_RE
## pp DATE_I_RE.source  ## note - will NOT include re flags (e.g. +i/insensitive)
## exit 1



## alternate date header (no brackets incl. year)
##     Aug 7 1999
##     Sep 4 1999
##    Oct 23 1999
##    Nov 20 1999
##    Apr 1 2000

HEADER_DATE_II_RE = %r{\A
      [ ]*
         #{date_(DATE_I_RE, DATE_II_RE)} 
      [ ]*
\z}ix



## 
## [Sep 16, Berchtold 26, Glasner 54, Kuljic 60]
## --- note - exclude  numbers in follow-up text!!!
##
##   use a shared pattern for city-like text !!
##      maybe allow more and make more specific later
#
##   exclude comma (,) - why? why not?
##    split in CITY_ and CITY_PLUS_ or such?
##    or find a better name ??
##
## allow number if:
##    Happel-Stadion, Wien, att: 9,200
##    Happel-Stadion, Wien; att: 7000
##    Innsbruck; att: 6700
##    Wörthersee-Stadion, Klagenfurt; att: 30,000
##    Wörthersee Stadion, Klagenfurt; att: 20,500
##  
## Apr 30, 28 Black Arena, Klagenfurt; att: 30,000
###   Wörthersee Stadion, known as 28 Black Arena for sponsorship reasons
##
##   Ernst-Happel-Stadion, Wien; att: 20100; ref: Hofmann

CITY_ = %q{   (?<city>  (?:   [^0-9:;\[\]]+? 
                            | .+? 
                                [ ] att: [ ] [0-9,]+
                                (?: [;,] [ ] ref: [ ] .+?  ## w/ optional ref: 
                                )?  
                         )        
               )    
          }


HEADER_DATE_N_CITY_RE = %r{\A
      [ ]*
      \[  #{date_(DATE_I_RE, 
                  DATE_II_RE)}
           , [ ]*
           #{CITY_} 
      \]
      [ ]*
\z}ix


###
##  alternate date header with brackets (in oost02.txt)
##   [31-08]  change to _ 31/08 _
##   [07-09]
##   [07-09]  
##   [30-05, Thaur]

HEADER_DATE_ALT_RE = %r{\A
      [ ]*
      \[  (?<date>
             (?<day> \d{1,2}) - (?<month> \d{1,2})
          )
          (?:
              , [ ]* 
              #{CITY_}
          )? 
      \]
      [ ]*
\z}ix







## Round 24 [Mar 21]
##  note - might be date range or date list
## Round 24 [Mar 21, 22]
## Round 24 [Mar 21-23]
## Round 2 [Aug 4-6]
## Round 1 [Aug 13-16]
## Round 2 [Aug 20-23]


HEADER_ROUND_N_DATE_RE = %r{\A
        [ ]*
         (?<round> #{ROUND_PAT})
         [ ]+
        \[ 
           #{date_(DATE_I_RE, DATE_IB_RE, DATE_II_RE, 
                   DATE_RANGE_RE,
                   DATE_LIST_RE, DATE_LEGS_RE)}   
        \]
        [ ]*
\z}ix


## Final [May 1, Klagenfurt]
HEADER_ROUND_N_DATE_N_CITY_RE = %r{\A
        [ ]*
         (?<round> #{ROUND_PAT})
         [ ]+
        \[  #{date_(DATE_I_RE, DATE_II_RE)}
             , [ ]*
           #{CITY_}    
        \]
        [ ]*
\z}ix


##
## reverse
##  Final [Graz, May 12]
## Super Cup Final [Graz, Jul 6]
## Final [London, Feb 27]
HEADER_ROUND_N_CITY_N_DATE_RE = %r{\A
        [ ]*
         (?<round> #{ROUND_PAT})
         [ ]+
        \[ #{CITY_}
             , [ ]*
            #{date_(DATE_I_RE, DATE_II_RE)}    
        \]
        [ ]*
\z}ix




#####
## note - line-by-line processing / matching
def _norm_date( m, format: nil )
   ## quick fix for undefined group name reference
   m = m.named_captures.transform_keys(&:to_sym)  if m.is_a?(MatchData)

  if m[:date_list]
    _fmt_date_list(_build_date_list( m ), format: format ) 
  elsif m[:date_legs]
    _fmt_date_legs(_build_date_legs( m ), format: format ) 
  elsif m[:date_range]
    _fmt_date_range(_build_date_range( m ), format: format ) 
  else   ## assume m[:date]
    _fmt_date(_build_date( m ), format: format )
  end
end


def handle_header( line )
      ## note - returns    newline (matched header line reformatted) 
      ##                    or nil (if no match!!)
      ##
       line = line.rstrip   ## expect chomp of newline "upstream" - why? why not?


      if m = HEADER_ROUND_RE.match(line.rstrip)
                   "▪ #{m[:round]} ▪\n" 
      elsif m = HEADER_DATE_RE.match(line.rstrip)
                   ## e.g. [Nov 20]
                   ## e.g. [April 1]   
                   date = _norm_date( m )
                   "_ #{date} _\n" 
      elsif m = HEADER_DATE_N_CITY_RE.match(line.rstrip)
                   ## e.g. [Jun 3, Ferrol] 
                   ## e.g. [Apr 2, Wembley]
                   date = _norm_date( m )
                   "_ #{date} _, #{m[:city]}\n" 
      elsif m = HEADER_DATE_II_RE.match(line.rstrip)
                    ##  note - no enclosing brackets []!!!
                    ## e.g. Nov 20 1999  or Nov 20, 1999
                    ##      Apr 1 2000   or Apr 1, 2000
                     date = _norm_date( m )
                   "_ #{date} _\n" 
      elsif m = HEADER_DATE_ALT_RE.match(line.rstrip)
                    ## e.g. [07-09]  
                    ##      [30-05, Thaur]
                    date = _norm_date( m, format: 'numeric' )
                    buf = String.new
                    buf += "_ #{date} _"
                    buf += ", #{m[:city]}"    if m[:city]
                    buf += "\n"
                    buf
      elsif m = HEADER_ROUND_N_DATE_RE.match(line.strip)
                     date = _norm_date( m )
                   "▪ #{m[:round]} ▪  #{date}\n"                   
      elsif m = HEADER_ROUND_N_DATE_N_CITY_RE.match(line.strip)
                     date = _norm_date( m )
                   "▪ #{m[:round]} ▪  #{date}, #{m[:city]}\n"  
      elsif m = HEADER_ROUND_N_CITY_N_DATE_RE.match(line.strip)
                     date = _norm_date( m )
                    ## note - reverse (rotate) date & city
                   "▪ #{m[:round]} ▪  #{date}, #{m[:city]}\n"  
       else
         nil 
       end
end



