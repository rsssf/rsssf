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
