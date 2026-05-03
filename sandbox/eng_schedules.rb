############
#  to run use:
#   $ ruby sandbox/eng.rb


require_relative 'helper'




title   = 'England (and Wales)'
root_dir  = '../clubs/england'
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




seasons = Season('2010/11')..Season('2023/24')

seasons.each do |season|
  puts "==> #{season}..."

  basename = "eng#{mkslug(season)}"
  page = Rsssf::Page.read_txt( "#{pages_dir}/#{basename}.txt")


  # note:  England 2010/11, 2011/12, 2012/13  uses
  #            Premiership  (not Premier League) for heading/section
  header = if season <= Season( '2012/13')
              'Premiership'
           else
              'Premier League'
           end

  sched = page.find_schedule!( header: header )
  sched.save( "#{root_dir}/#{season.to_path}/1-premierleague.txt",
              header: "= England | Premier League #{season}\n\n" )


  ###
  ###
  ##  == Cup Tournaments
  ##  === FA Cup
  ##  === League Cup
  if season < Season( '2015/16' )
    sched = page.find_schedule!( header: ['Cup Tournaments','FA Cup']  )
    sched.save( "#{root_dir}/#{season.to_path}/facup.txt",
                header: "= England | FA Cup #{season}\n\n" )

    sched = page.find_schedule!( header: ['Cup Tournaments','League Cup'] )
    sched.save( "#{root_dir}/#{season.to_path}/leaguecup.txt",
                header: "= England | League Cup #{season}\n\n" )
  end
end


## repo.make_schedules_summary


puts "bye"