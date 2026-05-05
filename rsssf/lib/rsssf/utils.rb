
module Rsssf
module Utils


## move to Page - why? why not?

def year_from_file( path )
  extname  = File.extname( path )
  basename = File.basename( path, extname )  ## e.g. duit92.txt or duit92.html => duit92
  year_from_name( basename )
end


def year_from_name( name )
  ## note - make sure it works for special case like:
  ##             mex2-2010  !!!

  if name =~ /( \d{4} | \d{2} )/x
    digits = $1.to_s
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
