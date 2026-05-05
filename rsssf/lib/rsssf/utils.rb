
module Rsssf
module Utils


## move to Page - why? why not?

def year_from_file( path )
  ## e.g. duit92.txt or duit92.html => duit92
  basename = File.basename( path, File.extname( path ))
  year_from_name( basename )
end




##  note - add lookbehind and lookahead for boundary NOT A NUMBER!!
##     other will match 4 digits in 5 digits number etc.
##                 or 2 digits in 3 digits number etc.

YEAR_FROM_NAME_RE = %r{ (?<! \d)       ## note - no digit before allowed
                        (?:  \d{4}
                           | \d{2} )
                      (?! \d)        ## no digit after allowed
                    }x

def year_from_name( name )
  ## note - make sure it works for special case like:
  ##             mex2-2010  !!!
  ##   only match  two digits (YY) or four digits (YYYY)

  if m=YEAR_FROM_NAME_RE.match( name )
    digits = m[0].to_s
    num    = digits.to_i(10)

    if digits.size == 4   ## e.g. 1980 or 2011 etc.
         num
    else ##  digits.size == 2  ## e.g. 00, 20 or 99 etc.
        ## assume 20xx for now from 00..09
        ## assume 19xx for 10..99
        num <= 9 ?  2000+num : 1900+num
    end
  else
    fail( "no year found in name #{name}; expected two or four digits")
  end
end  # method year_from_name



def archive_dir_for_season( season )
  season = Season( season )

  if season < Season('2010')   # e.g. season 2009-10
    ## use archive folder (w/ 1980s etc)
    ## get decade folder
    decade  = season.start_year     ## 1999/2000 2000
    decade -= decade % 10   ## turn 1987 into 1980 etc
    "archive/#{decade}s/#{season.to_path}"
  else
    season.to_path
  end
end



end  # module Utils
end  # module Rsssf
