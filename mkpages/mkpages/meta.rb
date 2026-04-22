

HTML_COMMENT_HEADER_RE = %r{  \A
                            [ \n]*  ## trailing spaces and blank lines
                       <!-- 
                            [ \n]* 
                          (?<text> .+?) 
                            [ \n]* 
                        -->
                   }imx


###
##   find meta data block (via html-style comment header )      
##    incl.   title, autor(s), url,  updated
##  e.g.
##    <!--
##       title:   Austria 2024/25
##       source:  https://rsssf.org/tableso/oost2025.html
##       author:  Hans Schöggl
##       updated: 7 Jul 2025    
##      -->
##  -or-
##      authors: Hans Schöggl and Karel Stokkermans 
              
def parse_meta( txt )
     meta = {}
     m = HTML_COMMENT_HEADER_RE.match( txt )
     if m
        text = m[:text]
        text.each_line do |line|
            line = line.strip

            ## note - allow "inline" blank lines and comment lines (starting w/ #)
            next if line.empty?  || line.start_with?('#') 

            ## split line on first colon (:) (only)
            ##   note - limit split to two pieces!!!
            key, value = line.split( /[ ]*:[ ]*/, 2)
            ## use a symbol (not string) as key - why? why not?
            meta[ key.to_sym ] = value
        end
        meta
     else
        nil ## no meta data (comment header) found
     end
end


