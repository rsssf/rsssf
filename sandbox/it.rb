############
#  to run use:
#   $ ruby sandbox/it.rb


require_relative 'helper'



proj = Rsssf::Project.new( '../clubs/italy',
                           title: 'Italy (Italia)',
                           slug:  'ital' )


proj.make_pages_summary


puts "bye"
