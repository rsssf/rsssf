

                 [ ]{0,5}  ## less than five spaces
                             ## avoids matching table headings 
 

TABLE_RE = %r{^     [ ]*   (?: (?<header>
                                  (?:   
                                      (?: final|fall|halfway) [ ] 
                                  )?
                                table 
                             |  final [ ] standings
                            ))
                           :?           ## note - optional colon
                         [ ]*
                          \n{1,2}       ## note - optional leading blank line!!

                        .*?             ## non-greedy - match everything (incl. newline!) until
                      (?:   \n (?= \n)    ## blank line (\n\n) or end-of-string/file
                          | \z
                      )
                    }ixm



   txt = txt.gsub( TABLE_RE ) do |match|
                 puts "  proc table block:"
                 puts match


                    ## remove everyting
                    ##  or put in comment block later with command line option/switch!! 
                    ##    ''
                   m = Regexp.last_match
    
## todo/check
##  maybe add line count too
##   e.g. (4 lines)

                     ## replace with "collapsed" marker
                    tables << match
                    table_id = tables.size 
                    "<!-- $table#{table_id}$ - #{m[:header]} -->\n"   
                  end
   txt


