############
#  to run use:
#   $ ruby sandbox/eng_pages.rb


require_relative 'helper'



proj = Rsssf::Project.new( '../clubs/england',
                           title: 'England (and Wales)',
                           slug:  'eng' )

proj.make_pages_summary

proj.make_schedules( <<TXT )
header,       seasons,             basename,          title
Premiership,      2010/11..2012/13,  1-premierleague,  England | Premier League {season}
Premier League,   2013/14..2023/24,  1-premierleague,  England | Premier League {season}

Cup Tournaments › FA Cup,     2010/11..2014/15,   facup,     England | FA Cup {season}
Cup Tournaments › League Cup, 2010/11..2014/15,   leaguecup, England | League Cup {season}
TXT

proj.make_schedules_summary


puts "bye"
