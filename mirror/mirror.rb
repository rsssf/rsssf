####
#  to run use:
#
#    $ ruby mirror/mirror.rb


$LOAD_PATH.unshift( '/sports/rubycocos/webclient/webclient/lib' )
$LOAD_PATH.unshift( '/sports/rubycocos/webclient/webget/lib' )


require 'cocos'
require 'webget'           ## incl. webget, webcache, webclient, etc.
require 'nokogiri'

require 'active_record'   ## todo: add sqlite3? etc.


Webcache.root = './cache'
Webget.config.delay_in_s = 1

## Webcache.root = '/sports/cache'   ## use "global" (shared) cache

BASE_URL = 'https://rsssf.org'


require_relative 'mirror/database'


require_relative 'mirror/find_links'  ## find_links helper 'n' more
require_relative 'mirror/download_page'
require_relative 'mirror/errata'     ## known typos & fixes

### commands
require_relative 'mirror/list'
require_relative 'mirror/mirror'


## auto log errors  (append to logs.txt)
def log( msg )
   ## append msg to ./logs.txt
   ##     use ./errors.txt - why? why not?
   File.open( './mirror/logs.txt', 'a:utf-8' ) do |f|
     f.write( msg )
     f.write( "\n" )
   end
end


=begin
## note - no longer used; mirror now records 404 (status) in mirror.db
##
## or use PAGES_NOT_FOUND ??
## GET https://rsssf.org/tablesm/mayotte2010.html...
## !! HTTP ERROR - 404 Not Found:

PAGES_404 = [
  '/tablesn/nedantcup09.html',
  '/tablesz/zimb2022.html',
  '/tablesm/mayotte2010.html',
  '/tablesj/jord2010.html',
  '/tablesv/vanuatu.html',
  '/tablesk/can08.html',
  '/tablesk/can07.html',
  '/tablesg/greenl07.html',
  '/tabless/syria05.html',
]
=end


##
##
##  defaults to windows-1252  if
###  lookup by path e.g. /curtour.html

PAGES_ENCODING = Hash.new { |h,key| h[key] = 'windows-1252'  }






if __FILE__ == $0

configs = parse_csv( <<TXT )

## starter pages for (recursive) mirror
##   if no encoding specified - assumes windows-1252 !!

page, encoding

/curdom.html
/curtour.html
/histdom.html
/intclub.html
/intland.html

/tableso/oost2026.html
/tablesi/ital2015.html

TXT

pp configs



def add_encodings( configs )
  configs.each do |config|
## todo / double check fix read_csv upstream
##    if   empty column has comment it is "" empty string otherwise
##                it is nil!!!  ??
        if config['encoding'].nil? || config['encoding'].empty?
            ## do nothing; use default (that is, windows-1252)
        else
           PAGES_ENCODING[config['page']] = config['encoding']
        end
  end
end






##
##  add/populate (known) encodings
## add_encodings( configs )


## MirrorDb.open( './mirror-test.db'  )
MirrorDb.open( './mirror.db'  )


## add seed/start pages
configs.each do |config|
      path     = config['page']
      encoding = config['encoding']
      encoding = 'windows-1252'      if config['encoding'].nil? || config['encoding'].empty?

      page_rec = MirrorDb::Model::Page.find_or_create_by!( path: path ) do |rec|
                      puts "  add page #{rec.path} (cached: false) to mirror.db"

                      rec.basename = File.basename( rec.path, File.extname( rec.path ))
                      rec.extname  = File.extname( rec.path )
                      rec.dirname  = File.dirname( rec.path )

                      rec.encoding = encoding
                      rec.cached   = false
                end
      pp page_rec
end

mirror_pages()


puts "bye"

end     ## if __FILE__ == $0




__END__

url = "https://user:pass@example.com:8080/path/page.html?foo=1&bar=2#section-3"
uri = URI.parse(url)

puts uri.scheme    # "https"
puts uri.user      # "user"
puts uri.password  # "pass"
puts uri.host      # "example.com"
puts uri.port      # 8080
puts uri.path      # "/path/page.html"
puts uri.query     # "foo=1&bar=2"
puts uri.fragment  # "section-3"
