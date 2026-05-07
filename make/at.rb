############
#  to run use:
#   $ ruby make/at.rb


require_relative 'helper'


pages = read_csv( './config/at.csv' )

prep = Rsssf::Prep.new
prep.convert_pages( pages, outdir: '../tables' )


##
## new step is fmtfix  ../tables => /austria/pages


proj = Rsssf::Project.new( '../clubs/austria',
                           title: 'Austria (Österreich)',
                           slug:  'oost' )



###
##  Season('1974/75')..Season('2023/24')   ## start 1974/75


proj.make_pages_summary

proj.make_schedules( <<TXT )
header,       seasons,             basename,          title
Bundesliga,   2010/11..2025/26,    1-bundesliga,  Austria | Bundesliga {season}
ÖFB Cup,      2010/11..2025/26,    cup,           Austria | ÖFB Cup {season}
TXT


proj.make_schedules_summary

puts "bye"
