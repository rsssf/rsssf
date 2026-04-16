

def handle_score( txt )

    ## fix typos - move to errata
    txt = txt.gsub( 'paet, 3-4 pen]', '[aet, 3-4 pen]' )
   
  


    ###  [aet]   => (aet)         -- after extra time
    ##   [asdet] => (asdet)      -- after sudden death extra time
    txt = txt.gsub( '[aet]',   '(aet)' )
    txt = txt.gsub( '[asdet]', '(asdet)' )

  


   ## [aet, 2-3 pen] => (aet, 2-3 pen)
   ##  [aet, 9-10 pen]
   ## [aet, 2-3pen]
   ## [aet, 7-6pen]

   txt = txt.gsub( %r{
                         \[
                            aet[,;.] [ ]? 
                             (\d{1,2}-\d{1,2}) [ ]? pen 
                         \]
                    }ix, 
                    '(aet, \1 pen)') 


###  [aet, pen 4-3]
##   [aet, pen 2-4]
###    =>
##      (aet, 2-4 pen)
   txt = txt.gsub( %r{
                         \[
                            aet[,;.] [ ]? 
                             pen [ ] (\d{1,2}-\d{1,2})
                         \]
                    }ix, 
                    '(aet, \1 pen)') 

 ##   [5-4 pen]
 ##   [3-4 pen]
 ##   [1-3 pen], [1-3pen]
   txt = txt.gsub( %r{
                         \[
                           (\d{1,2}-\d{1,2}) [ ]? pen
                         \]
                    }ix, 
                    '(\1 pen)') 

                    
##   [Pen 4-1], [Pen 4-5], [Pen 1-3]
##      => 
##    (4-1 pen)
   txt = txt.gsub( %r{
                         \[
                           pen [ ] (\d{1,2}-\d{1,2})
                         \]
                    }ix, 
                    '(\1 pen)') 
                  

##  [5-3 PK], [6-5 PK]    
##      =>
##   (6-5 pen)
      txt = txt.gsub( %r{
                           \[ 
                              (\d{1,2}-\d{1,2}) [ ] PK
                         \]
                        }ix,
                        '(\1 pen)'  )



 ##
 ## check special case usage - uniques?
 ##    [8-7 pen(no extra time)]
 ##    [Pen 2-4 (1-3?)]


   txt                 
end