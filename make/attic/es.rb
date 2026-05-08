############
#  to run use:
#   $ ruby make/es.rb


require_relative 'helper'

##
## Season('2010/11')..Season('2023/24')



proj = Rsssf::Project.new( '../clubs/spain',
                           title: 'Spain (España)',
                           slug:  'span' )


proj.make_pages_summary

proj.make_schedules( <<TXT )
header,       seasons,             basename,          title
Primera División,              2016/17..2024/25,   1-liga,  Spain | Primera División {season}
Primera División (Liga BBVA),  2010/11..2015/16,   1-liga,  Spain | Primera División {season}

Copa del Rey,                  2010/11..2020/21,     cup,   Spain | Copa del Rey {season}
TXT

proj.make_schedules_summary


puts "bye"
