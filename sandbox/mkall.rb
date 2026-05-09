############
#  to run use:
#   $ ruby sandbox/mkall.rb
#
#  merge configs into all.csv

require_relative 'helper'


## first-come,first-serve
##    if duplicate entry
##     merge props BUT keep first ones on conflict!!
##
##   note - order matters here!!
##   do NOT do a-z :-)

names = [
     ## by country
    'at',
    'br',
    'de',
    'eng',
    'es',
    'it',
    'mx',
    'us',

    ## worldcup
    'worldcup_full',
    'worldcup_quali',
    'worldcup',

    ## current domestic club leages & int'l national teams
    'curdom',
    'curdom2026',
    'curtour',

    ##'quick',
    ## 'quickii',
    ## 'quickiii',
]

pp names

rows_by_page = {}

##  keep/merge these columns
## { 'page',
##   'season',
##   'title',
##   'encoding'
## }
##

names.each do |name|
   file = find_file!( "#{name}.csv", path: ['./config'] )
   rows = read_csv( file )
   print file
   puts  "   #{rows.size} record(s)"

   rows.each do |row|
      page = row['page']   ## required
      raise ArgumentError, "page required in row #{row.inspect}"  if page.nil? || page.empty?

      rec = rows_by_page[page]
      if rec
         ## merge
         ## If different hashes share the same key,
         ##   the value from the last hash in the argument list wins.
         puts " note - merging >#{page}<:"
         one = {}.merge( rec, row ) do |key, old_val, new_val|
             ## do NOT overwrite encoding
             if key == 'encoding' || key == 'page'
                old_val
             else
                if new_val.nil? || new_val.empty?
                   old_val
                else
                    ## note: avoid duplicate adds too e.g.
                    ##   Mooréa|Tahiti|Mooréa|Tahiti
                   if old_val != new_val && !old_val.include?( new_val )
                      puts " adding #{key} value:  #{old_val} + #{new_val}"
                      old_val + '|' + new_val
                   else
                      old_val
                   end
                end
             end
         end
         ## pp rec
         ## pp row
         ## puts "  ==>"
         ## pp one
         rows_by_page[page] = one
      else
         ## new rec
         rows_by_page[page] = row.to_h
      end
   end
end


pp rows_by_page


##
## todo/check - maybe add count (usage) too - why? why not?

headers = ['season', 'page', 'title', 'encoding']

rows = rows_by_page.values.map { |rec| [ rec['season'],
                                          rec['page'],
                                          rec['title'],
                                          rec['encoding']]  }

write_csv( "./config/all.csv", rows, headers: headers )


puts  "   #{rows_by_page.size} record(s)"

puts "bye"
