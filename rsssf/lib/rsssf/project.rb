
module Rsssf


class Project
  include Utils       ## e.g. year_from_file, etc.



  attr_reader :title,
              :slug,
              :root_dir

def initialize( dir,
                title: 'Your Title Here',
                slug:  nil )
  @root_dir  = dir
  @title     = title
  @slug      = slug
end


def pages_dir()  "#{root_dir}/pages"; end


def _find_pages
  glob = "#{pages_dir}/**/*.txt"
  print "  glob >#{glob}<..."

  files = Dir.glob( glob )
  puts "  #{files.size} page(s) .txt found"

  ## pp files
  files
end


def make_pages_summary

  files = _find_pages()

  report = PageReport.build( files, title: @title )    ## pass in title etc.

  ### save report as README.md in pages/ dir in project root_dir
  report.save( "#{pages_dir}/README.md" )
end  # method make_pages_summary



def apply_heading_patches( patches )
  ### patch headings
  ##    if no headings found

  files = _find_pages()

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
end




def make_schedules_summary
   ## find all match datafiles
   ##    note - looks for season pattern for now
   ##                 YYYY-YY or YYYY
   glob = "#{root_dir}/**/{[12][0-9][0-9][0-9]-[0-9][0-9],[12][0-9][0-9][0-9]}/*.txt"
   print "  glob >#{glob}<..."
   files = Dir.glob( glob )
   puts "  #{files.size} datatfile(s) .txt found"
   pp files

   report = ScheduleReport.build( files, title: @title )   ## pass in title etc.
   report.save( "#{root_dir}/README.md" )
end






def each_page( seasons, &blk )
   seasons.each do |season|
      season = Season( season )
      basename = "#{slug}#{_mkslug(season)}"

      path = "#{pages_dir}/#{basename}.txt"
      page = Page.read_txt( path )

      blk.call( season, page )
   end
end




### rename to season_to_slug or such - why? why not?
def _mkslug( season )
    slug =  if season.end_year < 2010
                 ## cut off all digits (only keep last two)s
                 ##  convert end_year to string with leading zero
                 ## e.g. 00 / 01 / 99 / 98 / 11 / etc.
                 '%02d' % (season.end_year % 100)
              else
                 '%4d' % season.end_year
              end
    slug
end

end  ## class Project
end  ## module Rsssf
