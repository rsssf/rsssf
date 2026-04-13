
##
#  note - (re)use the same date regex style & capture names 
#                        from football.txt tokenizer

MONTH_LINES = parse_names( <<TXT )
January    Jan
February   Feb
March      Mar
April      Apr
May
June       Jun
July       Jul
August     Aug
September  Sept  Sep
October    Oct
November   Nov
December   Dec
TXT

MONTH_NAMES = build_names( MONTH_LINES )
# pp MONTH_NAMES
MONTH_MAP   = build_map( MONTH_LINES, downcase: true )
# pp MONTH_MAP


DAY_LINES = parse_names( <<TXT )
Monday                   Mon  Mo
Tuesday            Tues  Tue  Tu
Wednesday                Wed  We
Thursday    Thurs  Thur  Thu  Th
Friday                   Fri  Fr
Saturday                 Sat  Sa
Sunday                   Sun  Su
TXT

DAY_NAMES = build_names( DAY_LINES )
# pp DAY_NAMES
DAY_MAP   = build_map( DAY_LINES, downcase: true )
# pp DAY_MAP


#=>
# "January|Jan|February|Feb|March|Mar|April|Apr|May|June|Jun|
#  July|Jul|August|Aug|September|Sept|Sep|October|Oct|
#  November|Nov|December|Dec"
#
# "Monday|Mon|Mo|Tuesday|Tues|Tue|Tu|Wednesday|Wed|We|
#  Thursday|Thurs|Thur|Thu|Th|Friday|Fri|Fr|
#  Saturday|Sat|Sa|Sunday|Sun|Su"



###
#  br / pt -   future - add portugese / "brazilian"
#  Fevereiro
#  Outubro
# Novembro
#  Dezembro  e.g.
#
#  [9 Outubro]
#  [02 Novembro]
#  [09 Dezembro]
#  [02 Fevereiro 1989]






# e.g.      Aug 9
##      Fri Aug 9
##      Fri  Aug 9
##      Fri, Aug 9
##      Fri, Aug 9 2024
##      Fri, Aug 9, 2024
##           Aug 9, 2024
##           Aug 9, 2024
##   note - eat-up optional comma after DAY_NAMES!!
##
## add around for date not known perfectly 
##  around Mar 29
##  ca. Nov 1
##
##  Jan 25/87    - support two-digit year
##   Jan 28/87
##
##  extra/bonus -   allows (double) space typo for month day e.g
##                        Aug  9
DATE_I_RE = %r{
(?<date>
  \b
     ## optional around qualifier
     ((?<around>   around
                 | ca?\.)
                  [ ]
     )?
     ## optional day name
     ((?<day_name>#{DAY_NAMES})
           (?: ,?[ ]+)
     )?
     (?<month_name>#{MONTH_NAMES})
            [ ]{1,2}   ## note - allow (double) space typo
     (?<day>\d{1,2})
          \b
     ## optional year
     (   (?:      ,? [ ]       ## note - comma optional with single space required for now
                (?<year>\d{4})        ## optional year 2025 (yyyy)    
            |     / 
                (?<yy>\d{2})
          )  
            \b
     )?
)}ix


####  date i - alt style with weekday at the end (used in arg2026.txt) e.g.
##  Mar 23, Mon
##  Mar 25, Wed
##  Apr 1, Wed
##  May 3, Sun
##  Jul 26, Sun

DATE_IB_RE = %r{
(?<date>
  \b
     (?<month_name>#{MONTH_NAMES})
            [ ]{1,2}   ## note - allow (double) space typo
     (?<day>\d{1,2})
          , [ ]?
      (?<day_name>#{DAY_NAMES})
     \b
)}ix



###
## e.g. 3 June  
##     10 June
##   note - allow more spaces between  DAY_NAMES and DAY e.g.
##    Sun  1 Mar        
##    Wed  4 Mar        
##    Sat 14 Mar   
##    Sat 11 Apr 
##    Sat 11 Apr 2021
##
##    Sat, 11 Apr
##   note - eat-up optional comma after DAY_NAMES!!


DATE_II_RE = %r{
(?<date>
  \b
     ## optional day name
     ((?<day_name>#{DAY_NAMES})
           (?: ,?[ ]+)
     )?
     (?<day>\d{1,2})
         [ ]
     (?<month_name>#{MONTH_NAMES})
          \b
     ## optional year
     (?:  [ ]
        (?<year>\d{4})        ## optional year 2025 (yyyy)
        \b   
     )?
)}ix



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
##  - or -
## Nov 24 & 28
## Nov 24&28
##
# e.g.  Aug 9 & Aug 10
### note - allow shortcut e.g. Aug 9 & 10
##
##  note allow two-digit year
##   Jan 31 and Feb 4/87
##   Feb 1 and 4/87


DATE_LEGS_RE = %r{
(?<date_legs>
 \b
     (?<month_name1>#{MONTH_NAMES})
          [ ] 
     (?<day1>\d{1,2})
       (?:
             , [ ]{0,5} 
           | [ ]{1,5} and [ ]{1,5}
           | [ ]{0,5} & [ ]{0,5}
        )
    (?:     ## note - make 2nd month_name optiona
        (?<month_name2>#{MONTH_NAMES})
          [ ] 
      )?
     (?<day2>\d{1,2})
      \b
    ## optional two-digit year
     (?:    / 
          (?<yy2>\d{2})
            \b
     )?
)}ix


##
##  merge date_list and date_legs ??
##    or keep date_legs always with two dates by definition??
##   and date_list starting w/ three or more dates?
##
##    May 2,3,4
##    Feb 28, Mar 1,2

DATE_LIST_RE = %r{
(?<date_list>
 \b
     (?<month_name1>#{MONTH_NAMES})
          [ ] 
     (?<day1>\d{1,2})
     (?:  [,;] [ ]{0,5}  )


      (?:  ## note - make 2nd month_name optiona
        (?<month_name2>#{MONTH_NAMES})
          [ ] 
      )?
     (?<day2>\d{1,2})
       (?: [,;] [ ]{0,5}  )


      (?:     ## note - make 3rd month_name optiona
        (?<month_name3>#{MONTH_NAMES})
          [ ] 
      )?
     (?<day3>\d{1,2})
     \b


     ### optional fourth date
     (?:
         [,;] [ ]{0,5}
         (?:   ## note - make 4th month_name optiona
            (?<month_name4>#{MONTH_NAMES})
            [ ] 
         )?
       (?<day4>\d{1,2})
         \b
     )?
)}ix





###
## Aug 4-6
## Aug 13-16
## Aug 20-23
##   -or-
## Jul 30-Aug 1
## Sep 30-Oct 1
## Sep 29-Oct 1
## Mar 30-Apr 1


DATE_RANGE_RE = %r{
(?<date_range>
 \b
     (?<month_name1>#{MONTH_NAMES})
          [ ] 
     (?<day1>\d{1,2})
            [ ]? - [ ]?
    (?:   ## optional month
       (?<month_name2>#{MONTH_NAMES}) 
           [ ] 
    )?       
      (?<day2>\d{1,2})
     \b
)}ix






##  "internal" date helpers
def _build_date( m )
             ## quick fix for undefined group name reference
             m = m.named_captures.transform_keys(&:to_sym)  if m.is_a?(MatchData)

            date = {}
         ## map month names
         ## note - allow any/upcase JULY/JUL etc. thus ALWAYS downcase for lookup
            date[:y]  = m[:year].to_i(10)  if m[:year]
            ## check - use y too for two-digit year or keep separate - why? why not?
            date[:yy] = m[:yy].to_i(10)    if m[:yy]    ## two digit year (e.g. 25 or 78 etc.)
            date[:m] = m[:month].to_i(10)  if m[:month]
            date[:m] = MONTH_MAP[ m[:month_name].downcase ]   if m[:month_name]
            date[:d]  = m[:day].to_i(10)   if m[:day]
            date[:wday] = DAY_MAP[ m[:day_name].downcase ]   if m[:day_name]

            date[:around] = true     if m[:around]

            date
end

def _build_date_legs( m )
             ## quick fix for undefined group name reference
             m = m.named_captures.transform_keys(&:to_sym)  if m.is_a?(MatchData)

             legs = {}
            ## map month names
            ## note - allow any/upcase JULY/JUL etc. thus ALWAYS downcase for lookup
            date = {}
            date[:m] = MONTH_MAP[ m[:month_name1].downcase ]
            date[:d]  = m[:day1].to_i(10)   
            legs[:date1] = date
     
            date = {}
            date[:m] = MONTH_MAP[ m[:month_name2].downcase ]   if m[:month_name2]
            date[:d]  = m[:day2].to_i(10)   
            date[:yy] = m[:yy2].to_i(10)    if m[:yy2]    ## two digit year (e.g. 25 or 78 etc.)
            legs[:date2] = date

            legs
end 



def _build_date_list( m )
             ## quick fix for undefined group name reference
             m = m.named_captures.transform_keys(&:to_sym)  if m.is_a?(MatchData)

            list = {}
            ## map month names
            ## note - allow any/upcase JULY/JUL etc. thus ALWAYS downcase for lookup
            date = {}
            date[:m] = MONTH_MAP[ m[:month_name1].downcase ]
            date[:d]  = m[:day1].to_i(10)   
            list[:date1] = date
     
            date = {}
            date[:m] = MONTH_MAP[ m[:month_name2].downcase ]   if m[:month_name2]
            date[:d]  = m[:day2].to_i(10)   
            list[:date2] = date

            date = {}
            date[:m] = MONTH_MAP[ m[:month_name3].downcase ]   if m[:month_name3]
            date[:d]  = m[:day3].to_i(10)   
            list[:date3] = date

            if m[:day4] 
               date = {}
               date[:m] = MONTH_MAP[ m[:month_name4].downcase ]   if m[:month_name4]
               date[:d]  = m[:day4].to_i(10)   
               list[:date4] = date
            end

            list
end 


def _build_date_range( m )
             ## quick fix for undefined group name reference
             m = m.named_captures.transform_keys(&:to_sym)  if m.is_a?(MatchData)

             range = {}
            ## map month names
            ## note - allow any/upcase JULY/JUL etc. thus ALWAYS downcase for lookup
            date = {}
            date[:m] = MONTH_MAP[ m[:month_name1].downcase ]
            date[:d]  = m[:day1].to_i(10)   
            range[:date1] = date
     
            date = {}
            date[:m] = MONTH_MAP[ m[:month_name2].downcase ]   if m[:month_name2]
            date[:d]  = m[:day2].to_i(10)   
            range[:date2] = date

            range
end 


FMT_DAY_NAMES = [
    nil,   ##  or use '!ERROR!' - why? why not?
    'Mon',  # 1
    'Tue',  # 2
    'Wed',  # 3 
    'Thu',  # 4
    'Fri',  # 5
    'Sat',  # 6
    'Sun',  # 7
]
FMT_MONTH_NAMES = [
    nil,    ## or use '!ERROR!' - why? why not?
    'Jan',  # 1
    'Feb',  # 2
    'Mar',  # 3 
    'Apr',  # 4
    'May',  # 5
    'Jun',  # 6
    'Jul',  # 7
    'Aug',  # 8
    'Sep',  # 9
    'Oct',  # 10
    'Nov',  # 11
    'Dec',  # 12
]



def _fmt_date( date, format: nil )   ### use format: 'numeric' for  23/7 or 23/7/2010 etc.
    buf = String.new

    if format && format.downcase == 'numeric'
      buf << "#{date[:d]}/#{date[:m]}"
  
      if date[:y]       ## (optional) four-digit year e.g. 2010
        buf << "/#{date[:y]}"   
      elsif date[:yy]   ## (optional) two-digit year  e.g. 98
        buf << ("/%02d" % date[:yy])    ## note - make sure 0,1,2 become 00, 01, 02      
      end
  
      buf
    else    ## use Fri Feb 7 2025
      ## check for "canonical" convention for around/ca. date or such
      buf << "c. "   if date[:around]    
    
      buf << "#{FMT_DAY_NAMES[date[:wday]]} "  if date[:wday]
      buf << "#{FMT_MONTH_NAMES[date[:m]]} "
      buf << "#{date[:d]}"
   
  
      if date[:y]
         buf << " #{date[:y]}"  
      elsif date[:yy] 
         ## note - expand two-digit year to four-digit year
         buf << if date[:yy] < 30
                   ## note - make sure 0,1,2 become 00, 01, 02
                  " 20%02d" % date[:yy]   ## 2000, 2001, .. 2029 
                else
                 " 19%02d" % date[:yy]   ## 1930, 1931 .. 1999
                end
      end
      
      buf
    end

    buf 
end

def _fmt_date_legs( legs, format: nil )   ### use format: 'numeric' for  23/7 or 23/7/2010 etc.
    buf = String.new
    
    buf << "#{FMT_MONTH_NAMES[legs[:date1][:m]]} "
    buf << "#{legs[:date1][:d]}"
    buf << " & "
    buf << "#{FMT_MONTH_NAMES[legs[:date2][:m]]} "  if legs[:date2][:m] 
    buf << "#{legs[:date2][:d]}"
 
    if legs[:date2][:yy] 
         ## note - expand two-digit year to four-digit year
         buf << if legs[:date2][:yy] < 30
                   ## note - make sure 0,1,2 become 00, 01, 02
                  " 20%02d" % legs[:date2][:yy]   ## 2000, 2001, .. 2029 
                else
                 " 19%02d" % legs[:date2][:yy]   ## 1930, 1931 .. 1999
                end
    end
   
    buf 
end


def _fmt_date_list( list, format: nil )   ### use format: 'numeric' for  23/7 or 23/7/2010 etc.
    buf = String.new
    
    buf << "#{FMT_MONTH_NAMES[list[:date1][:m]]} "
    buf << "#{list[:date1][:d]}"
    
    if list[:date2][:m]  ## add extra space if month present
      buf << "; #{FMT_MONTH_NAMES[list[:date2][:m]]} "  
    else    
      buf << ","
    end
    buf << "#{list[:date2][:d]}"

    if list[:date3][:m]   ## add extra space if month present
      buf << "; #{FMT_MONTH_NAMES[list[:date3][:m]]} "
    else
      buf << ","
    end    
    buf << "#{list[:date3][:d]}"

    if list[:date4]  
      if list[:date4][:m]   ## add extra space if month present
         buf << "; #{FMT_MONTH_NAMES[list[:date4][:m]]} "
      else
         buf << ","
      end    
      buf << "#{list[:date4][:d]}"
    end


    buf 
end


def _fmt_date_range( range, format: nil )   ### use format: 'numeric' for  23/7 or 23/7/2010 etc.
    buf = String.new
    
    buf << "#{FMT_MONTH_NAMES[range[:date1][:m]]} "
    buf << "#{range[:date1][:d]}"
    buf << "-"
    buf << "#{FMT_MONTH_NAMES[range[:date2][:m]]} "  if range[:date2][:m] 
    buf << "#{range[:date2][:d]}"
 
    buf 
end
