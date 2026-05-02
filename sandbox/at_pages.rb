############
#  to run use:
#   $ ruby sandbox/at_pages.rb


require_relative 'helper'


title     = 'Austria (Österreich)'
pages_dir = '../clubs/austria/pages'

################
## collect pages & make page summary
files = Dir.glob( "#{pages_dir}/**/*.txt" )
report = Rsssf::PageReport.build( files, title: title )    ## pass in title etc.

### save report as README.md in tables/ folder in repo
report.save( "#{pages_dir}/README.md" )

puts "bye"
