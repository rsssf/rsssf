############
#  to run use:
#   $ ruby sandbox/at.rb


require_relative 'helper'




proj = Rsssf::Project.new( '../clubs/austria',
                           title: 'Austria (Österreich)',
                           slug:  'oost' )

proj.make_pages_summary

proj.make_schedules( <<TXT )
header,       seasons,             basename,          title
Bundesliga,   2010/11..2025/26,    1-bundesliga,  Austria | Bundesliga {season}
ÖFB Cup,      2010/11..2025/26,    cup,           Austria | ÖFB Cup {season}
TXT


proj.make_schedules_summary

puts "bye"
