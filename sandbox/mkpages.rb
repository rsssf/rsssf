############
#  to run use:
#   $ ruby sandbox/mkpages.rb 


require_relative 'helper'


pages = []
=begin
pages += read_csv( "./config/eng.csv" )
pages += read_csv( "./config/es.csv" )
pages += read_csv( "./config/de.csv" )
pages += read_csv( "./config/at.csv" )
pages += read_csv( "./config/br.csv" )
pages += read_csv( "./config/worldcup.csv" )
pages += read_csv( "./config/worldcup_quali.csv" )
=end

## pages += read_csv( "./config/curdom.csv" )
pages += read_csv( "./config/curtour.csv" )
pp pages


TITLE_RE = %r{
    <TITLE>(?<text>.*?)</TITLE>
}ixm



def find_title( html )
  if m=TITLE_RE.match( html )
     text = m[:text].strip
     ## note - convert html entities
     ##  e.g. Brazil 2000 - Copa Jo&atilde;o Havelange
     text = Rsssf::PageConverter.convert_html_entities( text )
     text
  else
     'n/a'
  end
end


##
##  Last updated: 22 Apr 1999
##  Last updated: 2 Apr 2005
## 
LAST_UPDATED_RE = %r{
       \b
       last [ ] updated: [ ]+ 
          (?<day>\d{1,2})  [ ]
          (?<month>[a-z]{3,10}) [ ] 
          (?<year>\d{4})
        \b    
}ixm

def find_last_updated( html )
  if m=LAST_UPDATED_RE.match( html )
      date = Date.strptime( "#{m[:day]} #{m[:month]} #{m[:year]}",
                            "%d %b %Y") 
      date.strftime( '%Y-%m-%d')  ## convert to iso date
  else
     'n/a'
  end
end


rows = []

pages.each do |config|
  encoding = config['encoding']
  page     = config['page']
  url      = "https://rsssf.org/#{page}"

  html = Webcache.read( url )
  ##  note - quick-fix known html errors
  ##   e.g  ##  <</TITLE> in tablesb/braz88.html 
  html = Rsssf::PageConverter.errata_html( html )


  title        = find_title( html )
  last_updated = find_last_updated( html )


   ## check for number of pre(formatted) blocks
   pres =  html.scan( /<PRE>/i )
   pre_count = pres.size.to_s

   puts "#{page}  =>  #{title}    #{last_updated}  #{pre_count}"

   rows << [page, title, last_updated, pre_count]
end


write_csv( "./config/curtour-pages.csv", rows, headers: ['page', 'title', 'updated', 'pre_count'] )



puts "bye"




