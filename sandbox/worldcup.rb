############
#  to run use:
#   $ ruby sandbox/worldcup.rb


require_relative 'helper'



pages = read_csv( "./sandbox/worldcup.csv" )


pages.each do |config|
    page = config['page']

    url  = "https://www.rsssf.org/#{page}"
    html = Webcache.read( url )

    basename = File.basename( page, File.extname( page ))

    puts
    puts "==> converting #{basename}..."

    txt = Rsssf::PageConverter.convert( html, url: url )

    write_text( "./tmp/#{basename}.txt", txt )
end


puts "bye"

