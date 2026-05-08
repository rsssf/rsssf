module Rsssf
class  Fmtfix    ## todo: find a better name e.g. Format or Fixer or ??


##
## note all "type" for round
##  eg. round  26   -  todo/fix - later use squish to autofix!!


## e.g. round 1, round 2, etc.
##      matchday 1
##      week 1
#   note - add optional   Matchday 1 of 2 or such
##      keep why? why not?
#
#  matchweek used by premerleague.com
#  week used in msl/usa (no matchdays/rounds)
#    note - matchweek might start on tuesday (e.g. tue to mon)
#                or check if always 7day week?
#
# note - use 1-9 regex (cannot start with 0) - why? why not?
#             make week 01 or round 01 or matchday 01 possible?

ROUND_PAT_BASE = %q{
         (   Round
           | Matchday
           | Matchweek
           | Week )   [ ]{1,2}  [1-9][0-9]*

        (?:    ## note - add optional   Matchday 1 of 2 or such
               [ ] of [ ] [1-9][0-9]*
        )?
}



##
## add more pattern via config
##
##  todo/fix - check if .txt is empty
##                 do NOT add ( || will match everything!!)
##
## rename names_misc to names_more - why? why not?

ROUND_NAMES_EN   = read_patterns( "#{Rsssf.config_dir}/rounds_en.txt" )
ROUND_NAMES_ES   = read_patterns( "#{Rsssf.config_dir}/rounds_es.txt" )
ROUND_NAMES_MISC = read_patterns( "#{Rsssf.config_dir}/rounds_misc.txt" )

ROUND_PAT = ROUND_PAT_BASE + ' | ' + ROUND_NAMES_EN.join( ' | ' ) +
                             ' | ' + ROUND_NAMES_ES.join( ' | ' ) +
                             ' | ' + ROUND_NAMES_MISC.join( ' | ' )
## pp ROUND_PAT


end    ## class Fmtfix
end    ## module Rsssf


__END__

"\n" +
"         (   Round\n" +
"           | Matchday\n" +
"           | Matchweek\n" +
"           | Week )   [ ]{1,2}  [1-9][0-9]*\n" +
"\n" +
"        (?:    ## note - add optional   Matchday 1 of 2 or such\n" +
"               [ ] of [ ] [1-9][0-9]*\n" +
"        )?\n" +
" | Preliminary [ ] round | (?:  First | Second | Third | Fourth | Fifth
 | 1st | 2nd | 3rd | 4th | 5th ) [ ] (?:  round (?:  [ ] replays? )? | phase )
 | Round [ ] one | (?:  1/32 | 1/16 | 16th | 1/8 | 8th | 1/4 | 1/2 ) [ ] finals?  (?:  [ ] replays? )?
 | (?:  Eight | Quarter | Semi ) [ -]? finals? (?:  [ ] replays? )?
 | Semis | Quarters | (?: Round [ ] of | Last ) [ ] (?:  4 | 8 | 16 | 32) | (?:  fifth | 5th ) [ -] place [ ] (?:  match | final | play[ -]?off ) | Match [ ] for [ ] (?:  fifth | 5th ) [ -] place | (?:  third | 3rd ) [ -] place [ ] (?:  match | final | play[ -]?off ) | Match [ ] for [ ] (?:  third | 3rd ) [ -] place | Finals? (?:  [ ] replays? )? | Final [ ] (?: round | group | pool) | (?: Minor | Major) [ ] Semi [ -]? finals? | Preliminary [ ] final | Final [ ] series | Grand [ ] final | Conference [ ] wild [ ] card [ ] round | Wild [ ] card [ ] games | (?: Eastern | Western) [ ] conference [ ] quarter [ -]? finals | (?: Eastern | Western) [ ] semi [ -]? finals | (?: Eastern | Western) [ ] conference [ ] final | Conference [ ] quarterfinals | Conference [ ] semifinals | Conference [ ] finals | Divisional [ ] finals | Championship [ ] final | MLS [ ] cup (?: [ ] final)? (?: [ ] \\d{4})? | Qualification [ ] MLS | Super [ ] semi [ -]? final | Super [ ]? cup [ ] final | Deciding [ ] match | Decider | play-?offs? [ ] round | Prime [ ] round | Round [ ] (?: 1|2|3) [ ] \\( no [ ] extra [ ] time \\) | Quarter [ -]? finals? [ ] \\( no [ ] extra [ ] time \\) | Moved [ ] match(?: es)? | match(?: es)? [ ] from [ ] round [ ] \\d{1,2} | Replays? | Replayed [ ] match(?: es)? | (?:  First | Second | Third | Fourth | Fifth | 1st | 2nd | 3rd | 4th | 5th ) [ ] stage | (?:  Regular | Group | League | Playoff ) [ ] stage | Knock-?out [ ] stage | Regular [ ] season | Tournament [ ] proper | Championship [ ] play-?offs? | Europa [ ] league [ ] play-?offs? | Conference [ ] league [ ] play-?offs? | Promotion [ ] (?: play-?offs? | match(?: es)?) | Relegation [ ] (?: play-?offs? | match(?: es)?) | Promotion/relegation [ ] (?: play-?offs? | match(?: es)?) | Promotion/relegation [ ] (?: play-?offs? | match(?: es)?) [ ] (?:  1st/2nd | 2nd/3rd | 3rd/4th) [ ] level | Relegation [ ] playout | Play-?out | Play-in [ ] round [ ] (?:  A | B | A-B ) | play-?offs? | play-?offs? [ ] (?: 1 | 2)? | (?:  First | Second | Third | Fourth | Fifth | 1st | 2nd | 3rd | 4th | 5th ) [ ] legs? (?:  [ ] replays? )? | Third [ ] leg [ ] minigame | Playoffs [ ] \\( Liguilla \\) | Recalificación | Round [ ] of [ ] 64 [ ] - [ ] 32 [ ] avos [ ] de [ ] final | Round [ ] of [ ] 32 [ ] - [ ] 16 [ ] avos [ ] de [ ] final | Round [ ] of [ ] 16 [ ] - [ ] Octavos [ ] de [ ] Final | Quarter [ ] finals [ ] - [ ] Cuartos [ ] de [ ] final | Semi [ ] finals [ ] - [ ] Semifinales | Primera [ ] fase [ ] de [ ] zonas [ ] - [ ] Phase [ ] of [ ] groups | Play-off [ ] o [ ] umístění | Skupina [ ] o [ ] záchranu"
