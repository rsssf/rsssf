############
#  to run use:
#   $ ruby sandbox/de.rb


require_relative 'helper'


proj = Rsssf::Project.new( '../clubs/germany',
                           title: 'Germany (Deutschland)',
                           slug:  'duit' )


patches = read_heading_patches( './sandbox/de_headings.txt' )
pp patches


### todo/fix - move upstream to fmtfix!!! - why? why not?
proj.apply_heading_patches( patches )


proj.make_pages_summary


proj.make_schedules_summary


puts "bye"




__END__



################
## collect pages & make page summary
files = Dir.glob( "#{pages_dir}/**/*.txt" )


report = Rsssf::PageReport.build( files, title: title )    ## pass in title etc.

### save report as README.md in tables/ folder in repo
report.save( "#{pages_dir}/README.md" )
