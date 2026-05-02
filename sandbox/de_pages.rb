############
#  to run use:
#   $ ruby sandbox/de_pages.rb


require_relative 'helper'


title     = 'Germany (Deutschland)'
pages_dir = '../clubs/germany/pages'


################
## collect pages & make page summary
files = Dir.glob( "#{pages_dir}/**/*.txt" )
report = Rsssf::PageReport.build( files, title: title )    ## pass in title etc.

### save report as README.md in tables/ folder in repo
report.save( "#{pages_dir}/README.md" )

puts "bye"
