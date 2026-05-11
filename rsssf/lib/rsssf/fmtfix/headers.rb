module Rsssf
class  Fmtfix    ## todo: find a better name e.g. Format or Fixer or ??



## let's you check optional ref e.g. ‹§fin›
OPT_REF = %q{
            (?: [ ]*
              ‹ (?<ref> §[^›]+?) ›
            )?
         }



=begin
## let's you check optional ref e.g. ‹§fin›
OPT_REF = %q{
            (?: [ ]*
              ‹§ (?<ref> [^›]+?) ›
            )?
         }
=end



def self._build_header_round_re( round_pat )
  ###
  ### note - allow optional colon e.g.
  ##     Playoff:
  ##     Round 21:

  %r{\A
        [ ]*
         (?<round> #{round_pat})
              :?   ## note - allow optional colon (:)  e.g. Playoff:
            #{OPT_REF}
         [ ]*
     \z}ix
end


HEADER_ROUND_RE = _build_header_round_re( ROUND_PAT )





## date header (w/ brackets)
##   [Aug 7]
##   [Oct 23]
##
###  note - might be date range or date list!!!
##   [Aug 7-9]
##   [Aug 7, 8]



## helper for inline regexes (with union) and escaped
def self.date_( *re )
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
##    Hayward, Calif.; att: 5.528   -- note: dot (.) NOT comma (,)
##
##
## Apr 30, 28 Black Arena, Klagenfurt; att: 30,000
###   Wörthersee Stadion, known as 28 Black Arena for sponsorship reasons
##
##   Ernst-Happel-Stadion, Wien; att: 20100; ref: Hofmann

CITY_ = %q{   (?<city>  (?:   [^0-9:;\[\]]+?
                            | .+?
                                [ ] att: [ ] [0-9,.]+
                                (?: [;,] [ ] ref: [ ] .+?  ## w/ optional ref:
                                )?
                         )
               )
          }


##  [Jun 3, Ferrol]
##  [Apr 2, Wembley]
##  -or-
##  [Sat May 17 - at Millennium Stadium, Cardiff]
##  [Sun May 25 - at Millennium Stadium, Cardiff]

HEADER_DATE_N_CITY_RE = %r{\A
      [ ]*
      \[  #{date_(DATE_I_RE,
                  DATE_II_RE)}
           (?:       , [ ]*
               | [ ] - [ ] at [ ]
            )
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
##
###  note - with optional ref/anchor
## Preliminary Round [Nov 20]  ‹§inplay›


def self._build_header_round_n_date_re( round_pat )
  %r{\A
        [ ]*
         (?<round> #{round_pat})
         [ ]+
        \[
           #{date_(DATE_I_RE, DATE_IB_RE, DATE_II_RE,
                   DATE_RANGE_RE,
                   DATE_LIST_RE, DATE_LEGS_RE)}
        \]
        #{OPT_REF}
        [ ]*
\z}ix
end

HEADER_ROUND_N_DATE_RE = _build_header_round_n_date_re( ROUND_PAT )





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


###
## Final [in Völs]
## Final [in Kundl]
HEADER_ROUND_N_CITY_RE = %r{\A
        [ ]*
         (?<round> #{ROUND_PAT})
         [ ]+
        \[in [ ]+ #{CITY_}
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



end    ## class Fmtfix
end    ## module Rsssf
