############
#  to run use:
#   $ ruby make/br.rb

require_relative  'helper'


##  note - special case for season 2000 => braz-joao00 !!!
## basename=>braz-joao00<
## basename=>braz01<
##
##   Season('1979')..Season('2024')


proj = Rsssf::Project.new( '../clubs/brazil',
                           title: 'Brazil (Brasil)',
                           slug:   -> (season) {  season == Season('2000') ?  'braz-joao' : 'braz' }
                         )

proj.make_pages_summary

proj.make_schedules( <<TXT )
header,       seasons,             basename,          title
Série A,    2010..2024,    1-seriea,  Brazil | Série A {season}
TXT

proj.make_schedules_summary



puts "bye"
