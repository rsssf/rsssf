require_relative 'helper'

code    = 'br'
seasons =  Season('1979')..Season('2024')

## code    = 'eng'
## seasons = Season('1992/93')..Season('2024/25')

## code    = 'de'
## seasons = Season('1963/64')..Season('2024/25')

## code    = 'es'
## seasons = Season('2010/11')..Season('2024/25')

## code    = 'at'
## seasons = Season('1974/75')..Season('2025/26')   ## start 1974/75 


pp seasons.to_a

rows = []
seasons.each do |season|
    page, encoding = Rsssf.table_page_n_encoding( code, season: season )
    rows << [season.to_s, page, encoding]
end
pp rows
write_csv( "./config/br.csv", rows, headers: ['season', 'page', 'encoding'] )



puts "bye"