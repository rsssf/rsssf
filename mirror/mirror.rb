####
#  to run use:
#
#    $ ruby mirror/mirror.rb



$LOAD_PATH.unshift( '/sports/rsssf/scripts/webget-mirror/lib' )
require 'webget/mirror'



require_relative '_cocos_'   ## move upstream into cocos!!!



Webcache.root = './cache'
Webget.config.delay_in_s = 1

## Webcache.root = '/sports/cache'   ## use "global" (shared) cache








if __FILE__ == $0


##
##  todo/check - use errata_html.txt - why? why not?
##
ERRATA_EDITS = read_edits( './mirror/errata.txt' )

##
##  defaults to windows-1252  if
###  lookup by path e.g. /curtour.html
PAGE_ENCODINGS = Hash.new { |h,key| h[key] = 'windows-1252'  }


site = Mirror::Website.new
site.base_url       = 'https://rsssf.org'

site.errata_edits   = ERRATA_EDITS
site.page_encodings = PAGE_ENCODINGS




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



site.start_pages = configs


## MirrorDb.open( './mirror-test.db'  )
MirrorDb.open( './mirror.db'  )


site.mirror_pages()



puts "bye"

end     ## if __FILE__ == $0
