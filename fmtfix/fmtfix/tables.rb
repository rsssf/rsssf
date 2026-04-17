


def table_heading_( line )
  ## M   W  T  L  GF  GA  PTS  AVGE
  ##  =>
  ## (?:
  ##   [ ]+ M  [ ]+  W [ ]+ T [ ]+ L [ ]+ GF [ ]+ GA [ ]+ PTS [ ]+ AVGE  [ ]*
  ##  )

   cols = line.strip.split( /[ ]+/ )

   "(?: [ ]+ #{cols.join(' [ ]+ ')} [ ]*)"
end





##
###   note - may start with blank line OR
##              header
##             followed by optional heading (e.g. M   W  T  L  GF  GA  PTS)
##        and table lines ( 1. rapid 38 17 ...)



TABLE_RE = %r{
      
           ### optional table header 
          (?:   
             ## (i) table header
             ##
             ## fix - make header match more strict!!!
             ##   e.g. do NOT match ---  or more than three spaces or such
             ## exlcude in header
             ##   NB:
             ##    [*]
             ##    [1]
             ## exclude heading === e.g.
             ##    ==== USL Premier Development
                  ^
                [ ]*
                  
             ### negative lookahead
             ##    MUST NOT match  standing line e.g.  10  3  4
             ##      or         table heading (see below)
             ##      or   -----  (old style structured heading left overs)
                    (?!    [^\n]+?  [ ]+ \d{1,3} [ ]+ \d{1,3} [ ]+ \d{1,3}
                        |  (?: GP | M |Team ) [ ]
                        |  -{3,}
                     )            

             (?<header>  [^=*:\[\]\n]+?)
                  :?  ## optional colon (:) e.g. final table: 
                  ## cut-off everything separated by more than three spaces
                  ##   e.g. might be "inline" table heading (follow table header name)
                  ##  e.g. Group 1                  M     W     T     L    GF    GA    DIF   PTS
                  (?: [ ]{4,} [^\n]+? )?
              [ ]*
             ## note - allow optional blank line - why? why not?   
             (?:  \n ^[ ]* )?
             \n
          )?
      
      
      #### optional  table heading line
      (?:  ^(?:  
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
  
         ^
         (?:  
               [^\n]+?
                 (?:
                    (?:

                      \d{1,3}
                 [ ]+ \d{1,3}  ## win   
                 [ ]+ \d{1,3}  ## draw   
                 [ ]+ \d{1,3}  ## lose   
                 [ ]+ \d{1,3}  (?:  [ ]* [:-] [ ]*  
                                  | [ ]+ )  \d{1,3} 
                 [ ]+ [+-]? \d{1,3} \b  # might be diff or point allow +/-!!
                   )
                   | (?:  ##  or compact/min form  -- 22  37-15  51
                          ##     maybe allow spaces later inbetween 37-15 - why? why not?
                         [ ]+ \d{1,3}                 ## played
                          [ ]+ \d{1,3} [ ]? -[ ]? \d{1,3}      ##  gf-ga
                          [ ]+  \d{1,3} \b            ##  pts
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


