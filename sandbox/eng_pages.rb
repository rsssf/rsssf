############
#  to run use:
#   $ ruby sandbox/eng_pages.rb


require_relative 'helper'


title   = 'England (and Wales)'
pages_dir = '../clubs/england/pages'


################
## collect pages & make page summary
files = Dir.glob( "#{pages_dir}/**/*.txt" )
report = Rsssf::PageReport.build( files, title: title )    ## pass in title etc.

### save report as README.md in tables/ folder in repo
report.save( "#{pages_dir}/README.md" )



puts "bye"