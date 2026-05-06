
module Rsssf


class Project
  include Utils       ## e.g. year_from_file, etc.



  attr_reader :title,
              :root_dir

def initialize( dir,
                title: 'Your Title Here',
                slug:  nil )
  @root_dir  = dir
  @title     = title
  @slug      = slug     ## note - might be a proc e.g.  ->(season) {}
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


def make_schedules( txt, archive: false )
   configs = parse_schedules( txt )
   ## pp configs

   configs.each do |config|
     header       = config['header']
     seasons      = config['seasons']
     basename     = config['basename'] || config['slug']
     title_tmpl   = config['title']


     ## note: header allows hierarchy e.g.  (see england and others)
     ##   Cup Tournaments › FA Cup  or
     ##   Cup Tournaments > FA Cup
     header_hiera = header.split( /[ ]* [›>] [ ]*/x )


     puts "==> #{header_hiera.join(' › ')} - #{seasons.size} season(s)..."

     i=0
     each_page( seasons ) do |season, page|
       title = title_tmpl.sub( '{season}', season.to_s )
        puts "  [#{i+1}/#{seasons.size}] #{season} => #{basename}, #{title}..."

       sched = page.find_schedule!( header: header_hiera )


        outpath =   if archive
                       ## use archive/1990s and such if season <= 2009/10
                       "#{root_dir}/#{archive_dir_for_season(season)}/#{basename}.txt"
                    else
                       "#{root_dir}/#{season.to_path}/#{basename}.txt"
                    end
       sched.save( outpath, header: "= #{title}\n\n" )
        i+=1
     end
  end
end





def each_page( seasons, &blk )
   seasons.each do |season|
      season = Season( season )
      basename = _mk_basename( season )

      path = "#{pages_dir}/#{basename}.txt"
      page = Page.read_txt( path )

      blk.call( season, page )
   end
end



def _mk_basename( season )
   slug =  @slug.is_a?(Proc) ? @slug.call( season ) : @slug

   ## e.g.  braz01, braz09 or braz2010
   basename = "#{slug}#{_mk_year(season)}"
   basename
end

def _mk_year( season )
##
##   note -  00, 01, 02, 03, 04, 05, 06, 07, 08, 09  => 2000, 2001, .. 2009
##           10, 11, 12, .. 99                       => 1910 !!, 1911, 1912, .. 1999
##
##            2010, 2011, 2012, ...
##
##    fix - check for 18xx ???  requires full year!!!
##     only 1910 to 2009  (10..09)

    slug =  if season.end_year >= 1910 &&
               season.end_year <  2010
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
