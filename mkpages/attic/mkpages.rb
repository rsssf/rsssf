
## note - allow no (empty) title? why? why not?                        
TITLE_PROP_RE = %r{ ^ [ ]* 
                        (?<key> title) 
                          [ ]*  :  [ ]* 
                        (?<value> .*?) 
                      [ ]*
                   $}ix



def find_title_in_comment( txt )
     comments = txt.scan( HTML_COMMENT_RE )
    
     ## assume first comment is "header" comments
     ##   note - match is an array of captures (even if only one capture) 
     comment = comments[0][0]
     if m = TITLE_PROP_RE.match( comment )
        m[:value]
     else
       nil
     end
end


    ## relative path 
    ##   note - will NOT include dirname!!!!
    ##    make add an option later - why? why not?
    ## - keep - why? why not?
    def txt_path()   "#{basename}.txt"; end
    def html_path()  "#{basename}.html"; end    



