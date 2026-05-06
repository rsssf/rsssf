############
#  to run use:
#   $ ruby sandbox/de.rb


require_relative 'helper'


## seasons = Season('1963/64')..Season('2023/24')
# seasons = Season('1999/2000')..Season('2023/24')
## seasons = Season('2020/21')..Season('2023/24')
## seasons = Season('1963/64')..Season('2023/24')



proj = Rsssf::Project.new( '../clubs/germany',
                           title: 'Germany (Deutschland)',
                           slug:  'duit' )


proj.make_pages_summary


proj.make_schedules( <<TXT, archive: true )
header,          seasons,             basename,          title
1. Bundesliga,    1999/2000..2024/25,  1-bundesliga,     Germany | Bundesliga {season}
DFB Pokal,        1996/97..2020/21,    cup,              Germany | DFB Pokal {season}
TXT


proj.make_schedules_summary


puts "bye"



__END__

  kwargs = if season <= Season('1998/99')
             {}  # no header; assume single league file; return empty hash
           else
             { header: '1. Bundesliga' }
           end
