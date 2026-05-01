####
#  to run use:
#
#    $ ruby mirror/mirror.rb


$LOAD_PATH.unshift( '/sports/rubycocos/webclient/webclient/lib' )
$LOAD_PATH.unshift( '/sports/rubycocos/webclient/webget/lib' )


require 'cocos'
require_relative 'mirror/_cocos_'    ## move (extenstions) upstream!!

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



##
##
##  defaults to windows-1252  if
###  lookup by path e.g. /curtour.html

PAGES_ENCODING = Hash.new { |h,key| h[key] = 'windows-1252'  }





HTML_CHARSET_RE = %r{
   <meta [ ]+
       [^<>]*?        ## note - use non-greedy (shortest) match
  \bcharset
        [ ]*=[ ]*
          ['"]?       ## optional opening quote
        (?<charset>[a-z0-9-]+)
}ix


HTML_DOCTYPE_RE = %r{
   <!DOCTYPE [ ]+
        (?<doctype> [^<>]+?)  ## note - use non-greedy (shortest) match
                               ## do NOT allow opening/closing brackets for now
                               ##  ever possible? double check
            [ ]*
   >
}ix






if __FILE__ == $0

configs = parse_csv( <<TXT )

## starter pages for (recursive) mirror
##   if no encoding specified - assumes windows-1252 !!

page, encoding

##  /index.html
##  not really use all pages link to  /nersssf.html  (basically the same page)
##

/archive.html
/guide.html

/curtour.html
/curdom.html
/histdom.html
/intclub.html
/intland.html

/misc.html
/recent.html


# /tableso/oost2026.html
# /tablesi/ital2015.html

TXT

pp configs




##
## to be done - add knownencodings
=begin
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
=end



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
