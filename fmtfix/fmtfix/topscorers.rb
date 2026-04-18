
##
## process/handle Topscoreres: ... to first blank line (\n\n)


## e.g.
##  topscorer, topscorers
##  top scorer, top scorers
##  scorer, scorers

TOPSCORERS_RE = %r{^     [ ]* 
                        (?<header> 
                           (?: top [ ]?)?  ## note - optional top
                              scorers?      ## singular or plural 
                         )
                          (?: [ ]* :)?    ## note - optional colon
                           [ ]*
                          \n{0,2}       ## note - optional leading blank line!!

                        .*?             ## non-greedy - match everything until
                      (?:   \n (?= \n)    ## blank line (\n\n) or end-of-string/file
                          | \z
                      )
                    }ixm

                    
def handle_topscorers( txt, topscorers: [], opts: {} )
   txt = txt.gsub( TOPSCORERS_RE ) do |match|
                 if opts[:topscorers]
                   puts "  proc topscorers block:"
                   puts match
                 end
                 
                    ## remove everyting
                    ##  or put in comment block later with command line option/switch!! 
                    ##    ''
                    
                    ## replace with "collapsed" marker
                      topscorers << match
                    topscorers_id = topscorers.size 
                    "<!-- $topscorers#{topscorers_id}$ -->\n\n"   
                  end
   txt
end


