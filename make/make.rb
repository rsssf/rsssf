##
# to run use:
#   ruby make/make.rb  <config_slug>

require_relative 'helper'


configs = {
  'at' => { dir:    "#{CLUBS_DIR}/austria",
            title:  'Austria (Österreich)',
            slug:   'oost' },

  'de' => { dir:    "#{CLUBS_DIR}/germany",
            title: 'Germany (Deutschland)',
            slug:  'duit',
            archive: true },

##  note - special case for season 2000 => braz-joao00 !!!
## basename=>braz-joao00<
## basename=>braz01<
##
##   Season('1979')..Season('2024')
  'br' => { dir:   "#{CLUBS_DIR}/brazil",
            title: 'Brazil (Brasil)',
            slug:   -> (season) {  season == Season('2000') ?  'braz-joao' : 'braz' },
          },

  'eng' => { dir:  "#{CLUBS_DIR}/england",
             title: 'England (and Wales)',
              slug:  'eng' },

  'es' =>  { dir: "#{CLUBS_DIR}/spain",
             title: 'Spain (España)',
             slug:  'span' },

  'it' => {  dir: "#{CLUBS_DIR}/italy",
             title: 'Italy (Italia)',
             slug:  'ital' },

  ##
  ##  note - season 2020  has special page =>  mex2-2010 (not mex2010)  !!!
  'mx' => {  dir: "#{CLUBS_DIR}/mexico",
             title: 'Mexico (México)',
             slug:  ->(season) { season == Season('2010') ? 'mex2-' : 'mex' }
          },

  'us' =>  { dir: "#{CLUBS_DIR}/usa",
             title: 'USA (and Canada)',
             slug: 'usa'
           },
}




args = ARGV


if args.size == 0
  puts "error: argument required e.g. eng, at, etc."
  exit 1
end


code = args.shift  ## get first argument

config = configs[code]
if config.nil?
    puts "error: no config found for code >#{code}<; sorry"
end



pages = read_csv( "./config/#{code}.csv" )
pp pages


prep = Rsssf::Prep.new
prep.convert_pages( pages, outdir: TABLES_DIR )


##
## new step is fmtfix  ../tables => /pages
heading_patches_file = "./make/#{code}_headings.txt"
heading_patches =   if File.file?( heading_patches_file )
                           Rsssf::Fmtfix.read_heading_patches( heading_patches_file )
                    else
                         nil
                    end


fmtfix = Rsssf::Fmtfix.new


round_patterns_file = "./make/#{code}_rounds.txt"
round_patterns  =   if File.file?( round_patterns_file )
                        ###
                        ## build (custom) patterns
                        ##
                          patterns = read_patterns( round_patterns_file )


                          {
                             header_round:        Rsssf::Fmtfix._build_header_round_re( patterns ),
                             header_round_n_date: Rsssf::Fmtfix._build_header_round_n_date_re( patterns ),
                          }
                    else
                         nil
                    end


fmtfix.fmtfix_pages( pages, path: [ TABLES_DIR ],
                            heading_patches: heading_patches,
                            round_patterns:  round_patterns,
                            outdir: "#{config[:dir]}/pages")


proj = Rsssf::Project.new( config[:dir],
                           title: config[:title],
                           slug:  config[:slug] )


proj.make_pages_summary     ## generates pages/README.md



schedules_file = "./make/#{code}_schedules.csv"
schedules_txt  = if File.file?( schedules_file )
                           read_text( schedules_file )
                    else
                         nil
                    end

if schedules_txt
  proj.make_schedules( read_text( schedules_file ), archive: config[:archive] || false )
  proj.make_schedules_summary   ## generates  README.md
end



puts "bye"
