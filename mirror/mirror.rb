####
#  to run use:
#
#    $ ruby mirror/mirror.rb



$LOAD_PATH.unshift( '/sports/rsssf/scripts/webget-mirror/lib' )
require 'webget/mirror'

require_relative 'mirror/_cocos_'   ## move upstream into cocos!!!



Webcache.root = './cache'
Webget.config.delay_in_s = 1

## Webcache.root = '/sports/cache'   ## use "global" (shared) cache





class Rsssf <   Mirror::Website       ##  or use Mirror


  def initialize
     self.base_url = 'https://rsssf.org'
  end

##
##
##  defaults to windows-1252  if
###  lookup by path e.g. /curtour.html

PAGES_ENCODING = Hash.new { |h,key| h[key] = 'windows-1252'  }

   def page_encoding( path ) PAGES_ENCODING[ path ]; end


  ##
  ##  todo/check - use errata_html - why? why not?
  ##

ERRATA_EDITS = read_edits( './mirror/errata.txt' )

  def errata( html, url: )
     ## lookup edits by path e.g. /tablesp/poland-satrip77.html
     ##                       or  /miscellaneous/torre-madrid.html

     page_url = URI( url )

     edits = ERRATA_EDITS[page_url.path]

     ## note - for now always use gsub (not sub)
     ##   maybe add option later
     if edits
        edits.each do |search,replace|
                        html = html.gsub( search, replace )
                   end
     end

     html
  end
end ## class Rsssf






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




site = Rsssf.new
site.start_pages = configs


## MirrorDb.open( './mirror-test.db'  )
MirrorDb.open( './mirror.db'  )


site.mirror_pages()



puts "bye"

end     ## if __FILE__ == $0
