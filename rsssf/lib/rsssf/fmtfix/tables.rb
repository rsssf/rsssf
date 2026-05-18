module Rsssf
class  Fmtfix    ## todo: find a better name e.g. Format or Fixer or ??




def self.table_heading_( line )
  ## M   W  T  L  GF  GA  PTS  AVGE
  ##  =>
  ## (?:
  ##   [ ]* M  [ ]+  W [ ]+ T [ ]+ L [ ]+ GF [ ]+ GA [ ]+ PTS [ ]+ AVGE  [ ]*
  ##  )

   cols = line.strip.split( /[ ]+/ )

   "(?: [ ]* #{cols.join(' [ ]+ ')} [ ]*)"
end





TABLE_RE = %r{

         ### optional table header
          (?:
             ## (i) table header
             ###    note - only "generic" names for now
             ##      only allow "generic" titles such as:
             ##         - final table/fall table/standings table/table etc.
             ##
             ##     do NOT allow leagues names or group 1/2/3 etc.
             ##
             ##   why?  keep it simple

                 ^
                [ ]*
                 (?<header>
                      Final [ ] table
                    | Halfway [ ] table
                    | Fall [ ] table
                    | Table [ ] at [ ] abandonment
                    | Table
                    | Final [ ] standings
                 )
                  [ ]*
                   ## optional colon (:)
                     (?:  : [ ]* )?

                  ## note - allow optional blank line - why? why not?
                     (?:  \n ^[ ]* )?
                   \n
           )?


      #### optional  table heading line
      (?:
         ^
         (?:
          #{table_heading_( 'GP  W   L   D  GF  GA  PTS?' )}
        | #{table_heading_( 'GP  W   L   T  GF  GA  PTS?' )}
        | #{table_heading_( 'GP  W   T   L  GF  GA  PTS?' )}
        | #{table_heading_( 'GP  W   D   L  GF  GA  PTS?' )}
        ##  SW  sudden death win, SL sudden death lose
        | #{table_heading_( 'GP  W   L  SW  GF  GA  PTS?' )}
        | #{table_heading_( 'GP  W SW  SL   L   GF  GA  PTS?' )}
        | #{table_heading_( 'GP  W SOW SOL  L  GF  GA PTS?'   )}
        ##  mx/spanish
        | #{table_heading_( 'M   W   T   L  GF  GC  DIF  PTS' )}
        | #{table_heading_( 'M   W   T   L  GF  GA PTS AVGE' )}
        | #{table_heading_( 'Team  M  W  T  L  GF-GA  PTS')}
        | #{table_heading_( 'Team   M  W  T  L  GF-GA  PTS EP  TP')}
        ## eng
        | #{table_heading_( 'Pos Team   P   W   D   L   F   A  GD Pts')}
        | #{table_heading_( 'P  W  D  L   F-A  Pts')}
        ## br
        | #{table_heading_( 'TEAM   Pts   P   W   D   L   GF   GA   DIF')}

        )
       ## note - allow optional blank line - why? why not?
          (?: \n ^[ ]* )?
            \n
      )?


  ## MUST be followed by a table (standing) line
  ## e.g.  1.FC Cincinnati    34  20  9  5  57-39  69
  ##
  ##   note - allow "run-on" e.g. LB14 on first number
  ## Hudson Valley Quickstrike LB14  12   0   2   40   9   38
  ## Hudson Valley Quickstrike LB12  11   1   0   26   9   33
  ##
  ##    17    11     5     1    40    16    +24    38
  ##  or
  ###  + 1.DC United                       32 17  6/ 3  6 65-43 57

         ^
         (?:
               [^\n]+?
                 (?:
                    (?:

                      \d{1,3}
                 [ ]+ \d{1,3}  ## win
 (?: [ ]+ | [ ]* / [ ]* ) \d{1,3}  ## draw
                 [ ]+ \d{1,3}  ## lose
                 [ ]+ \d{1,3}  (?:  [ ]* [:-] [ ]*
                                  | [ ]+ )  \d{1,3}
                 [ ]+ [+-]? \d{1,3} \b  # might be diff or point allow +/-!!
                   )
                 )
               [^\n]*?
          )
         \n

         ## eat-up the rest
         .*?   ## non-greedy - match everything (incl. newline!) until
                 (?:   \n (?= \n)    ## break on blank line (\n\n) or end-of-string/file
                          | \z
                 )

}ixm




def handle_tables( txt, tables: [] )


   txt = txt.gsub( TABLE_RE ) do |match|

                 m = Regexp.last_match

                 puts "  proc table >#{m[:header]}< block:"
                 puts ">>> (begin)"
                 puts match
                 puts "<<< (end)"

                    ## remove everyting
                    ##  or put in comment block later with command line option/switch!!
                    ##    ''

                     ## replace with "collapsed" marker



                    tables << match
                    table_id = tables.size
                    if m[:header]   ## note - header might be missing
                                    ##   table starting w/ blank line
                       "<!-- $table#{table_id}$ - #{m[:header]} -->\n"
                    else
                       "<!-- $table#{table_id}$ -->\n"
                    end
                  end
   txt
end


end    ## class Fmtfix
end    ## module Rsssf
