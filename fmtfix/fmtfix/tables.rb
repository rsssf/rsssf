


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



##
## note simple/compact table standing format needs more thinking
##   will match
## FC Schalke 04        1-3  1. FSV Mainz 05
## Hannover 96          3-1  1. FC Nürnberg
## FC Schalke 04        0-1  1. FC Kaiserslautern
## Hannover 96          2-0  1. FSV Mainz 05
## FSV Mainz 05             3-1 1. FC Köln
##
##   - add a required ranking  in the beginning e.g. 1., 2. or such?

=begin
                   | (?:  ##  or compact/min form  -- 22  37-15  51
                          ##     maybe allow spaces later inbetween 37- 15 - why? why not?
                          ##    1. 1. FC Köln   30 17 11  2  78- 40  45

                         [ ]+ \d{1,3}                 ## played
                          [ ]+ \d{1,3} [ ]? -[ ]? \d{1,3}      ##  gf-ga
                          [ ]+  \d{1,3} \b            ##  pts
                     )
=end


=begin
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


              ## exclude comma (,) - why? why not?
              ##   and numbers  - unless group 1
              ## e.g. Kaczor 78 - Dreßel 19, Steinkogler 50,
              ## B'schweig  2-1 Schalke    (Handschuh 38, Popivoda 55 - Fischer 82)
              ##  M'gladbach 2-1 1. FC Köln (Jensen 6, Wittkamp 35 - D.Müller 78)
              ##   Kraft 3, E.Kremers 38)
              ##  Schalke     4-0 Tasmania    (Klose 2, 78, Herrmann 40, Kreuz 82)
              ##
              ## allow name such as
              ##    USL - 1ST DIVISION (2nd Division)


             (?<header>  [^=*:,0-9\[\]\n]+?
                          ([ ] \d{1,2} \b)?   ## optional number only at the end e.g. group 1
                     )
                  :?  ## optional colon (:) e.g. final table:
=end


TABLE_HEADER_RE = %r{
      ############
      ## negative & positive lookaheads

##         (?!
##               .* [ ]{2,}       ## no (inline)  double (or more) spaces allowed
##         )

      (?:
      ## (i)  can only start with non-zero number
      ##      or alpha
      ##
      ##  A.  or
      ##  1.  or
      ##   mixed with dot  1A. yes/no?, A1. yes/no?,  1B1. ?
      ##   1.K    - 1.Klasse

      ##
      ##  note - \b(oundary) - to always get complete tokens (alphanum) tokens
      ##            note - \b includes [a-z0-9_] PLUS underscore (_)
      ##                          check if underscore is \b
      ##                              e.g.   09_  or _09 or  match \b[0-9]\b  ???
      ##   use our own asserts?
      ##      BNUM (boundary number) e.g. [^0-9]
      ##      BALPHA (boundary alpha) e.g. [^a-z]
      ##      BALNUM (boundary alphanum) e.g. [^a-z0-9]
      ##    classic is   [^a-z0-9_]

         (?<header>
          (?=
              .*  \p{L}+    ## must incl. alpha character - not only numbers!!
          )

  ## note
  ##   order matters
  ##   move specific first!!

            \b
             (?:     [0-9]+\p{L}  [0-9\p{L}]* \b    ## (ii) mixed alphanum (starting w/ num)
                |    [0-9]+  \b  \.?  (?! \d)    ## (i)  num
                |  \p{L}+[0-9]  [0-9\p{L}]* \b     ## (iiii) mixed alphanum (starting w/ alpha)
                |  \p{L}+  \b    \.?              ## (iii) alpha
             )
             (?:
                ## " (i-iiii) connector options  (a) single space
                ##                                   -- exclude numbers on numbers (FIX)
                ##                               (b) dash (-) or slash (/)
                ##                                  --  must be alpha(.?)-alpha
                ##                                        incl.  K.-H.  with trailing dot
                ##                              add ampersand (&) too
                ##                                    w/ leading & trailing opt space?
                ##                                                incl.  K.&H., K. & H.
               (?:   [ ]?
                   | (?<! \d)  -   ## add negative lookbehind&ahead (no numbers please)
                     (?! \d)
                   |  /
                )
                    ## repeat (i-iiii) see above
                       ## todo - do NOT allow numbers followed by numbers
                \b
                (?:  [0-9]+ \b    (?! [ ] \d)     ## (i) num - no more ordinals - why? why not?
                  |  [0-9]+\p{L}  [0-9\p{L}]* \b     ## (ii) mixed alphanum (starting w/ num)
                                                  ##     group 1a 1FC?? - why? why not?
                  |  \p{L}+  \b   \.?              ## (iii) alpha
                  |  \p{L}+[0-9]  [0-9\p{L}]* \b   ## (iiii) mixed alphanum (starting w/ alpha)
               )
            )*
            (?:
                 [ ]
                \(  [^:()\[\]]+?  \)
            )?
        )  ## end-of-capture header
   )
   :?    ## optional colon (:) e.g. final table:
}ix


TABLE_RE = %r{

         ### optional table header
          (?:
             ### negative lookahead
             ##    MUST NOT match  standing line e.g.  10  3  4
             ##      or         table heading (see below)
             ##      or   -----  (old style structured heading left overs)
                    (?! ^[ ]* (?:   [^\n]+?  [ ]+ \d{1,3} [ ]+ \d{1,3} [ ]+ \d{1,3}
                                |   (?: GP | M | Team ) [ ]
                                |  -{3,}
                              )
                     )

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


              ## exclude comma (,) - why? why not?
              ##   and numbers  - unless group 1
              ## e.g. Kaczor 78 - Dreßel 19, Steinkogler 50,
              ## B'schweig  2-1 Schalke    (Handschuh 38, Popivoda 55 - Fischer 82)
              ##  M'gladbach 2-1 1. FC Köln (Jensen 6, Wittkamp 35 - D.Müller 78)
              ##   Kraft 3, E.Kremers 38)
              ##  Schalke     4-0 Tasmania    (Klose 2, 78, Herrmann 40, Kreuz 82)
              ##
              ## allow name such as
              ##    USL - 1ST DIVISION (2nd Division)


             (?<header>  [^=*:,0-9\[\]\n]+?
                          ([ ] \d{1,2} \b)?   ## optional number only at the end e.g. group 1
                     )
                  :?  ## optional colon (:) e.g. final table:
                  ## cut-off everything separated by more than three spaces
                  ##   e.g. might be "inline" table heading (follow table header name)
                  ##  e.g. Group 1                  M     W     T     L    GF    GA    DIF   PTS
                  (?: [ ]{4,} (?: GP | M |Team ) [ ]  [^\n]+? )?
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
