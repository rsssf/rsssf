

def handle_score( txt )

    ## fix typos - move to errata
    txt = txt.gsub( 'paet, 3-4 pen]', '[aet, 3-4 pen]' )
    ##   [aet. 3-5 pen]  => [aet,]
    txt = txt.gsub( '[aet. ', '[aet, ')
  


   ###  [aet]  => (aet)
    txt = txt.gsub( '[aet]', '(aet)' )
   ##   [asdet] => (asdet)
    txt = txt.gsub( '[asdet]', '(asdet)' )

  
   ## [aet, 2-3 pen] => (aet, 2-3 pen)
   ##  [aet, 9-10 pen]
   ## [aet, 2-3pen]
   ## [aet, 7-6pen]

   txt = txt.gsub( %r{
                         \[
                           ( aet, [ ]? 
                             \d{1,2}-\d{1,2} [ ]? pen )
                         \]
                    }ix, 
                    '(\1)') 

###  [aet, pen 4-3]
##   [aet, pen 2-4]
   txt = txt.gsub( %r{
                         \[
                           ( aet, [ ]? 
                             pen [ ] \d{1,2}-\d{1,2})
                         \]
                    }ix, 
                    '(\1)') 

 ##   [5-4 pen]
 ##   [3-4 pen]
 ##   [1-3 pen]
   txt = txt.gsub( %r{
                         \[
                           (\d{1,2}-\d{1,2} [ ]? pen)
                         \]
                    }ix, 
                    '(\1)') 

                    
##   [Pen 4-1], [Pen 4-5], [Pen 1-3]
   txt = txt.gsub( %r{
                         \[
                           (pen [ ] \d{1,2}-\d{1,2})
                         \]
                    }ix, 
                    '(\1)') 
                  


 ##
 ## check special case usage - uniques?
 ##    [8-7 pen(no extra time)]
 ##    [Pen 2-4 (1-3?)]


   txt                 
end