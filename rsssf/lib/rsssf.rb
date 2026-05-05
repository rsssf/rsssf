
## 3rd party (our own)
require 'season/formats'   ## add season support
require 'webget'           ## incl. webget, webcache, webclient, etc.

require 'cocos'


## (old) 3rd party libs
##  require 'textutils'      ## used for File.read_utf8 etc.
## require 'fetcher'        ## used for Fetcher::Worker.new.fetch etc.


#######
##   add RsssfParser too
## require 'rsssf/parser'    ## from rsssf-parser gem




## our own code
require_relative 'rsssf/version'    # note: let version always go first

require_relative 'rsssf/utils'      # include Utils - goes first

require_relative 'rsssf/download'

require_relative 'rsssf/convert/convert'
require_relative 'rsssf/convert/html_entities'
require_relative 'rsssf/convert/html_to_txt'
require_relative 'rsssf/convert/errata'
require_relative 'rsssf/convert/html_to_txt/replace_heading'
require_relative 'rsssf/convert/html_to_txt/replace_a_name'
require_relative 'rsssf/convert/html_to_txt/replace_a_href'
require_relative 'rsssf/convert/html_to_txt/replace_hr'
require_relative 'rsssf/convert/html_to_txt/remove_emails'
require_relative 'rsssf/convert/html_to_txt/beautify_anchors'
require_relative 'rsssf/convert/html_to_txt/make_heading'



require_relative 'rsssf/page'
require_relative 'rsssf/page-find_schedule.rb'

require_relative 'rsssf/schedule'

require_relative 'rsssf/reports/schedule'
require_relative 'rsssf/reports/page'

require_relative 'rsssf/repo_v0'   ### replace with projct
require_relative 'rsssf/project'   ### replace with projct

require_relative 'rsssf/parse_schedules'

require_relative 'rsssf/patch_headings'



#############
## add (shortcut) alias(es)
RsssfPage           = Rsssf::Page
RsssfPageConverter  = Rsssf::PageConverter
RsssfPageStat       = Rsssf::PageStat
RsssfPageReport     = Rsssf::PageReport

RsssfSchedule       = Rsssf::Schedule
RsssfScheduleStat   = Rsssf::ScheduleStat
RsssfScheduleReport = Rsssf::ScheduleReport

RsssfRepo           = Rsssf::Repo
RsssfUtils          = Rsssf::Utils



## say hello
puts Rsssf.banner   ##  if defined?($RUBYLIBS_DEBUG) && $RUBYLIBS_DEBUG
