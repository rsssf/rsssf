############
#  to run use:
#   $ ruby sandbox/de_pages.rb


require_relative 'helper'


title     = 'Germany (Deutschland)'
pages_dir = '../clubs/germany/pages'


################
## collect pages & make page summary
files = Dir.glob( "#{pages_dir}/**/*.txt" )


patches = read_heading_patches( './sandbox/de_headings.txt' )
pp patches

##  maybe move upstream??
### patch headings
##    if no headings found
files.each do |file|

  page = Rsssf::Page.read_txt( file )
  headings = page._scan_headings()

  if headings.size == 0
     puts "==> #{File.basename(file,File.extname(file))}"
     page.txt = patch_headings( page.txt, patches )

     ## save only if headings added/found
     headings = page._scan_headings()
     if headings.size > 0

        puts "headings:"
        pp headings

        write_text( file, page.txt )
     end
  end
end




report = Rsssf::PageReport.build( files, title: title )    ## pass in title etc.

### save report as README.md in tables/ folder in repo
report.save( "#{pages_dir}/README.md" )

puts "bye"
