
module Rsssf



    ## map country codes to table pages
    ##   add options about (char) encoding ??? - why? why not?
  TABLE = {
    'eng' => ['tablese/eng{year}.html',   { encoding: 'windows-1252' } ],
    'es'  => ['tabless/span{year}.html',  { encoding: 'windows-1252' } ],
    'de'  => ['tablesd/duit{year}.html', { encoding: 'windows-1252' } ],
    'at'  => ['tableso/oost{year}.html',
                 { encoding:
                     ->(season) {
                        if season <= Season('1998/99')
                          'windows-1252'
                        else
                          'iso-8859-2'
                        end
                     }
                }  ],
    'br'  => [
              ->(season) {
                  ## note: special slug/case for year/season 2000
                  ##  see rsssf.org/tablesb/brazchamp.html
                 if season == Season('2000')
                   'tablesb/braz-joao{year}.html'  ## use braz-joao00 - why? why not?
                 else
                   'tablesb/braz{year}.html'
                 end
              },
              { encoding: 'Windows-1252' } ],
  }


  BASE_URL = "https://rsssf.org"


  def self.table_url( code, season: )
     url, _ = table_url_n_encoding( code, season: season )
     url
  end

  def self.table_url_n_encoding( code, season: )
     page, encoding = table_page_n_encoding( code, season: season )
     url = "#{BASE_URL}/#{page}"

     [url, encoding]
  end


  def self.table_page_n_encoding( code, season: )
     season = Season( season )


     ##
     ##  note  00,01,02..09  => 2000,2001,..2009
     ##        10,11,12..99  => 1910,1911...1999
     ##
     ##    2010,2011,...

     ## e.g. 1998/99   =>  99
     ##      1999/2000 =>  00
     ##      2000/01   =>  01
     ##      2001/02   =>  02
     ##      ..
     ##      2008/09   =>  09
     ##      2009/10   =>  2010 !!
     ##      2010/11   =>  2011 !!

     slug =  if season.end_year < 2010
                 ## cut off all digits (only keep last two)s
                 ##  convert end_year to string with leading zero
                 ## e.g. 00 / 01 / 99 / 98 / 11 / etc.
                 '%02d' % (season.end_year % 100)
              else
                 '%4d' % season.end_year
              end


     table = TABLE[ code.downcase ]

     tmpl     = table[0]
     opts     = table[1] || {}

     tmpl     = tmpl.call( season )  if tmpl.is_a?(Proc)  ## check for proc
     tmpl = tmpl.sub( '{year}', slug )



     encoding = opts[:encoding]  || 'utf-8'
     encoding = encoding.call( season )  if encoding.is_a?(Proc)  ## check for proc


     page = tmpl

     [page, encoding]
  end



  def self.download_table( code, season: )
     url, encoding = table_url_n_encoding( code, season: season )

     download_page( url, encoding: encoding )
  end


end # module Rsssf