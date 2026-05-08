############
#  to run use:
#   $ ruby make/at.rb


require_relative 'helper'


###
##  Season('1974/75')..Season('2023/24')   ## start 1974/75


pages = read_csv( './config/at.csv' )

prep = Rsssf::Prep.new
prep.convert_pages( pages, outdir: TABLES_DIR )


##
## new step is fmtfix  ../tables => /austria/pages

heading_patches =  Rsssf::Fmtfix.read_heading_patches( './make/at_headings.txt' )

fmtfix = Rsssf::Fmtfix.new
fmtfix.fmtfix_pages( pages, path: [ TABLES_DIR ],
                            heading_patches: heading_patches,
                            outdir: "#{CLUBS_DIR}/austria/pages")



proj = Rsssf::Project.new( "#{CLUBS_DIR}/austria",
                           title: 'Austria (Österreich)',
                           slug:  'oost' )



proj.make_pages_summary

proj.make_schedules( read_text( './make/at_schedules.csv' ))
proj.make_schedules_summary

puts "bye"
