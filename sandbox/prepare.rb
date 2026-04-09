############
#  to run use:
#   $ ruby sandbox/prepare.rb   dataset e.g. at/worldcup/etc.


require_relative 'helper'

##
# step 1 - download all world cup "full" pages

args = ARGV

if args.size == 0
  puts "error: argument required e.g. worldcup, at, etc."
  exit 1
end


opts = {
   force: false     ## true
}

code = args.shift  ## get first argument

outdir = "./tmp3"

## outdir = "../england/tables"
## outdir = "../europe/germany/tables"
## outdir = "../europe/spain/tables"
## outdir = "../europe/austria/tables"
## outdir = "../worldcup/pages"


pages = read_csv( "./config/#{code}.csv" ) 
pp pages


## pass 1 - download
pages.each do |config|
  encoding = config['encoding']
  page     = config['page']
  url      = "https://rsssf.org/#{page}"

  ## check if not in cache  
  ##   note - use force == true  to always (force) download
  if  Webcache.cached?( url ) && opts[:force] == false
      puts "   CACHE HIT - #{url}"
  else
      Rsssf.download_page( url, encoding: encoding )
  end
end
          
## pass 2 - convert
pages.each_with_index do |config,i|
  encoding = config['encoding']
  page     = config['page']
  url      = "https://rsssf.org/#{page}"

  html     = Webcache.read( url )
  
  basename = File.basename( page, File.extname( page ))

  puts
  puts "==> [#{i+1}/#{pages.size}] converting #{basename}..."

  txt = Rsssf::PageConverter.convert( html, url: url )

  write_text( "#{outdir}/#{basename}.txt", txt )
end


puts "bye"


