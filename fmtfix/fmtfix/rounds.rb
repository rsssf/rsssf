

##
## note all "type" for round
##  eg. round  26   -  todo/fix - later use squish to autofix!! 


ROUND_PAT = %q{
               Round [ ]{1,2} \d{1,2}     ## e.g. round 1, round 2, etc.
        
             | Preliminary [ ] round

             | (?:   First | Second | Third | Fourth | Fifth
                   | 1st | 2nd | 3rd | 4th | 5th) 
                   [ ] round  
                   (?: [ ] replays?)?

             | (?: First | Second | 1st | 2nd) [ ] phase 
                   
             | 1/16 [ ] finals

             | 1/8 [ ] finals?  
             | Eightfinals 

             | Quarter [ -]? finals 
             | Semi [ -]? finals? 
             
             | Third [ ] place [ ] match 
             | Match [ ] for [ ] third [ ] place 

             | Final 
               (?: [ ] group | pool | replay)? 
             
             | Super [ ]? cup [ ] final

             | Deciding [ ] match

             ## add stages
             | Regular [ ] stage
             | Playoff [ ] stage 
             | Championship [ ] playoff
             | Relegation [ ] playoff
             | Europa [ ] league [ ] playoff 
             | Conference [ ] league [ ] playoff
             | Promotion/relegation [ ] playoff
             
             ## standalone legs
             | First [ ] legs? 
             | Second [ ] legs?

             
             ## standalone replay
             | Replay

             ## groups
             | Group [ ] (?:   [a-z]             ## e.g  group a, group b,
                          | \d{1,2}            ##      group 1, group 2,
                          | i | ii | iii | iv  ##      group i, group ii, etc.
                         )

             ## standalone playoff
             | Playoff                

}        

