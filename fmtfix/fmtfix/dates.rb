

WDAY_NAMES_PAT = %q{
                      (?:       Mon
                              | Tue
                              | Wed
                              | Thur | Thu 
                              | Fri
                              | Sat
                              | Sun
                            )
}

MONTH_NAMES_PAT   = %q{  
                      (?:     Jan
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
                            | Dec 
                        )
} 


## classic date pattern
###  e.g. Jan 1
##        Dec 31

DATE_PAT = %Q{
              #{MONTH_NAMES_PAT} [ ] \\d{1,2}                           
}


###
## Aug 4-6
## Aug 13-16
## Aug 20-23
##   -or-
## Jul 30-Aug 1
## Sep 30-Oct 1
## Sep 29-Oct 1
## Mar 30-Apr 1


DATE_RANGE_PAT = %Q{
                          #{DATE_PAT}
                              -
                      (?:   ## optional month
                            #{MONTH_NAMES_PAT} 
                               [ ] 
                      )?       
                            \\d{1,2}
}

###
## Aug 4,5
## Aug 13,14
## Aug 20,21
## Mar 4, 5
## Mar 11, 12
## Apr 1, 2
##  -or-
## Nov 24 and 27  - use in br
## Nov 24 and 28
## - or - 
## Feb 27 and Mar 7
## Feb 28 and Mar 7



##  fix/fix/fix
## change to 
##  DATE_LEG_PAT !!!   (if only two dates possible)

DATE_LIST_PAT = %Q{
                          #{DATE_PAT}
                              (?:        , [ ]?
                                   | [ ] and [ ]
                               )
                            (?:   ## optional month
                                #{MONTH_NAMES_PAT}
                                  [ ] 
                             )?       
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
DATE_WDAY_DAY_MON_PAT  = %Q{
                             #{WDAY_NAMES_PAT}
                                [ ]      
                              \\d{1,2}
                                 [ ]
                            #{MONTH_NAMES_PAT}
}

###
## 
## Wed Feb 6
## Sat Feb 16
## Tue Feb 26
DATE_WDAY_MON_DAY_PAT  = %Q{
                             #{WDAY_NAMES_PAT}
                                 [ ]
                            #{MONTH_NAMES_PAT}     
                                 [ ]      
                              \\d{1,2}
}

