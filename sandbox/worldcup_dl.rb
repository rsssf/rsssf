
############
#  to run use:
#   $ ruby sandbox/worldcup_dl.rb


##
# step 1 - download all world cup "full" pages


require_relative 'helper'



pages = read_csv( "./sandbox/worldcup.csv" ) 
pp pages


pages.each do |config|
  encoding = config['encoding']
  page     = config['page']
  url      = "https://www.rsssf.org/#{page}"

  html = Rsssf.download_page( url, encoding: encoding )
end



puts "bye"