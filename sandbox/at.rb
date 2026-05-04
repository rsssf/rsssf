############
#  to run use:
#   $ ruby sandbox/at.rb


require_relative 'helper'




proj = Rsssf::Project.new( '../clubs/austria',
                           title: 'Austria (Österreich)',
                           slug:  'oost' )

proj.make_pages_summary




seasons = Season('2010/11')..Season('2025/26')


##
##  mapper - use a text config e.g.

#######
##   header,    seasons,       slug, title
##  Bundesliga,     ..,        1-bundesliga,  Austria | Bundesliga {season}
##  ÖFB Cup,        ..,        cup,           Austria | ÖFB Cup {season}



proj.each_page( seasons ) do |season, page|
  puts "==> #{season}..."

  sched = page.find_schedule!( header: 'Bundesliga' )
   sched.save( "#{proj.root_dir}/#{season.to_path}/1-bundesliga.txt",
              header: "= Austria | Bundesliga #{season}\n\n" )

  sched = page.find_schedule!( header: 'ÖFB Cup' )
  sched.save( "#{proj.root_dir}/#{season.to_path}/cup.txt",
              header: "= Austria | ÖFB Cup #{season}\n\n" )

end


proj.make_schedules_summary




puts "bye"





__END__

################
## collect pages & make page summary
files = Dir.glob( "#{pages_dir}/**/*.txt" )
report = Rsssf::PageReport.build( files, title: title )    ## pass in title etc.

### save report as README.md in tables/ folder in repo
report.save( "#{pages_dir}/README.md" )


seasons = Season('2010/11')..Season('2025/26')

seasons.each do |season|
  puts "==> #{season}..."

  basename = "oost#{mkslug(season)}"
  page = Rsssf::Page.read_txt( "#{pages_dir}/#{basename}.txt")

  sched = page.find_schedule!( header: 'Bundesliga' )
   sched.save( "#{root_dir}/#{season.to_path}/1-bundesliga.txt",
              header: "= Austria | Bundesliga #{season}\n\n" )

  sched = page.find_schedule!( header: 'ÖFB Cup' )
  sched.save( "#{root_dir}/#{season.to_path}/cup.txt",
              header: "= Austria | ÖFB Cup #{season}\n\n" )

end
