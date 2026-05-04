############
#  to run use:
#   $ ruby sandbox/de_schedules.rb


require_relative 'helper'




title     = 'Germany (Deutschland)'
root_dir  = '../clubs/germany'
pages_dir = "#{root_dir}/pages"



def mkslug( season )
    slug =  if season.end_year < 2010
                 ## cut off all digits (only keep last two)s
                 ##  convert end_year to string with leading zero
                 ## e.g. 00 / 01 / 99 / 98 / 11 / etc.
                 '%02d' % (season.end_year % 100)
              else
                 '%4d' % season.end_year
              end
    slug
end


## seasons = Season('1963/64')..Season('2023/24')
# seasons = Season('1999/2000')..Season('2023/24')
## seasons = Season('2020/21')..Season('2023/24')

seasons = Season('1963/64')..Season('2023/24')

seasons.each do |season|
  puts "==> #{season}..."

  basename = "duit#{mkslug(season)}"
  page = Rsssf::Page.read_txt( "#{pages_dir}/#{basename}.txt")

  if season > Season('1998/99')
    sched = page.find_schedule!( header: '1. Bundesliga' )
    sched.save( "#{root_dir}/#{archive_dir_for_season(season)}/1-bundesliga.txt",
              header: "= Germany | Bundesliga #{season}\n\n" )
  end

  if season >= Season('1996/97') &&
     season <= Season('2020/21')
    sched = page.find_schedule!( header: 'DFB Pokal' )
    sched.save( "#{root_dir}/#{archive_dir_for_season(season)}/cup.txt",
                header: "= Germany | DFB Pokal #{season}\n\n" )
  end
end

puts "bye"




__END__

repo.each_page( code, seasons ) do |season,page|
  puts "==> #{season}..."

  kwargs = if season <= Season('1998/99')
             {}  # no header; assume single league file; return empty hash
           else
             { header: '1\. Bundesliga' }
           end
  sched = page.find_schedule( **kwargs )
  sched.save( "#{repo.root}/#{archive_dir_for_season(season)}/1-bundesliga.txt",
              header: "= Deutsche Bundesliga #{season}\n\n" )


  if season >= Season('1996/97')
    sched = page.find_schedule( header: 'DFB Pokal', cup: true )
    sched.save( "#{repo.root}/#{archive_dir_for_season(season)}/cup.txt",
                header: "= DFB Pokal #{season}\n\n" )
  end
end


cfg = RsssfScheduleConfig.new
cfg.name = '1-bundesliga'
cfg.opts_for_year = ->(year) {
  if year <= 1999
    {}  # no header; assume single league file; return empty hash
  else
    { header: '1\. Bundesliga' }
  end
}
## for debugging - use filer (to process only some files)
## cfg.includes = [1964, 1965, 1971, 1972, 2014, 2015]


cfg.name = 'cup'
cfg.opts_for_year =  { header: 'DFB Pokal', cup: true }

## for debugging - use filer (to process only some files)
cfg.includes = (1997..2015).to_a
