
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

HEADER_DATE_RE = %r{\A
      [ ]*
      \[ (?<date> 
                  (?: #{DATE_PAT})
                | (?: #{DATE_RANGE_PAT})
                | (?: #{DATE_LIST_PAT})
         ) 
      \]
      [ ]*
\z}ix

#### alternate daher header with year (brackets)
## [Aug 18, 2004]
## [Sep 4, 2004]
## [Sep 8, 2004]
## [Nov 19, 2003]
## [Oct 15, 2008]
## [Mar 26, 2004]

HEADER_DATE_IIA_RE = %r{\A
      [ ]*
      \[
          (?<date> #{DATE_YYYY_PAT}) 
      \]
      [ ]*
\z}ix

## alternate date header (no brackets incl. year)
##     Aug 7 1999
##     Sep 4 1999
##    Oct 23 1999
##    Nov 20 1999
##    Apr 1 2000

HEADER_DATE_IIB_RE = %r{\A
      [ ]*
       (?<date> #{DATE_YYYY_PAT}) 
      [ ]*
\z}ix





## alternate date header (weekkday day mon)
## [Wed 6 Feb]
## [Sat 16 Feb]
## [Tue 26 Feb]
HEADER_DATE_III_RE = %r{\A
      [ ]*
       \[
       (?<date> #{DATE_WDAY_DAY_MON_PAT}) 
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
      \[ (?<day> \d{1,2}) - (?<month> \d{1,2})
          (?:
              , [ ]* 
              (?<city> .+?)
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
             (?<date>   (?: #{DATE_PAT})
                      | (?: #{DATE_RANGE_PAT})
                      | (?: #{DATE_LIST_PAT})
              ) 
        \]
        [ ]*
\z}ix


## Final [May 1, Klagenfurt]
HEADER_ROUND_N_DATE_N_CITY_RE = %r{\A
        [ ]*
         (?<round> #{ROUND_PAT})
         [ ]+
        \[ (?<date> #{DATE_PAT})
             , [ ]*
           (?<city> .+?)    
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
        \[ (?<city> .+?)
             , [ ]*
           (?<date> #{DATE_PAT})    
        \]
        [ ]*
\z}ix





