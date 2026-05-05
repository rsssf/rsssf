############
#  to run use:
#   $ ruby sandbox/us.rb


require_relative 'helper'


proj = Rsssf::Project.new( '../clubs/usa',
                           title: 'USA (and Canada)',
                           slug: 'usa'  )


proj.make_pages_summary


puts "bye"
