

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

names_en   = read_patterns( "#{config_dir}/rounds_en.txt" )
names_es   = read_patterns( "#{config_dir}/rounds_es.txt" )
names_misc = read_patterns( "#{config_dir}/rounds_misc.txt" )

ROUND_PAT = ROUND_PAT_BASE + ' | ' + names_en.join( ' | ' ) +
                             ' | ' + names_es.join( ' | ' ) +
                             ' | ' + names_misc.join( ' | ' )   
pp ROUND_PAT



