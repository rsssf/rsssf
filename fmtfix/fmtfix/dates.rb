



## classic date pattern
DATE_PAT = %q{
                           (  Jan
                            | Feb
                            | March | Mar
                            | April | Apr 
                            | May
                            | June | Jun
                            | July | Jul
                            | Aug
                            | Sept | Sep
                            | Oct
                            | Nov
                            | Dec )
                             [ ]      
                            \d{1,2}                           
}


###
## Aug 4-6
## Aug 13-16
## Aug 20-23
DATE_RANGE_PAT = %Q{
                          #{DATE_PAT}
                              -
                            \\d{1,2}
}

###
## Aug 4,5
## Aug 13,14
## Aug 20,21
## Mar 4, 5
## Mar 11, 12
## Apr 1, 2

DATE_LIST_PAT = %Q{
                          #{DATE_PAT}
                              ,[ ]?
                            \\d{1,2}
}



###   Aug 7 1999
##   Sep 4 1999
## Oct 23 1999
## Nov 20 1999
## Apr 1 2000
##
##  note - allow - optional comma
##   Aug 18, 2004
##   Sep 4, 2004
##   Sep 8, 2004
##   Nov 19, 2003
##   Oct 15, 2008

## note - big Q ("") requires double backslash escapes!!
DATE_YYYY_PAT = %Q{
                            #{DATE_PAT}
                               ,?
                               [ ]
                            \\d{4}                           
                           } 


###
## 
## Wed 6 Feb
## Sat 16 Feb
## Tue 26 Feb
DATE_WDAY_DAY_MON_PAT  = %q{
                            (   Mon
                              | Tue
                              | Wed
                              | Thu
                              | Fri
                              | Sat
                              | Sun
                            )
                             [ ]      
                            \d{1,2}
                             [ ]      
                           (  Jan
                            | Feb
                            | March | Mar
                            | April | Apr 
                            | May
                            | June | Jun
                            | July | Jul
                            | Aug
                            | Sept | Sep
                            | Oct
                            | Nov
                            | Dec )                            
}
