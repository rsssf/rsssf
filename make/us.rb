############
#  to run use:
#   $ ruby make/us.rb


require_relative 'helper'


proj = Rsssf::Project.new( '../clubs/usa',
                           title: 'USA (and Canada)',
                           slug: 'usa'  )


proj.make_pages_summary


puts "bye"
