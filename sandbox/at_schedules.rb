############
#  to run use:
#   $ ruby sandbox/at_schedules.rb


require_relative 'helper'





title     = 'Austria (Österreich)'
root_dir  = '../clubs/austria'
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



seasons = Season('2010/11')..Season('2025/26')

seasons.each do |season|
  puts "==> #{season}..."

  basename = "oost#{mkslug(season)}"
  page = Rsssf::Page.read_txt( "#{pages_dir}/#{basename}.txt")

  sched = page.find_schedule!( header: 'Bundesliga' )
   sched.save( "#{root_dir}/#{season.to_path}/1-bundesliga.txt",
              header: "= Austria | Bundesliga #{season}\n\n" )

  sched = page.find_schedule!( header: 'ÖFB Cup' )
  sched.save( "#{root_dir}/#{season.to_path}/cup.txt",
              header: "= Austria | ÖFB Cup #{season}\n\n" )

end


### repo.make_schedules_summary


puts "bye"