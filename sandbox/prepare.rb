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
   force:  false ## true    ## false     ## true
}

code = args.shift  ## get first argument

## outdir = "./tmp-curtour"
outdir = "../tables"

## outdir = "../brazil/tables"
## outdir = "../england/tables"
## outdir = "../europe/germany/tables"
## outdir = "../europe/spain/tables"
## outdir = "../europe/austria/tables"
## outdir = "../worldcup/pages"


pages = read_csv( "./config/#{code}.csv" ) 
pp pages


TITLE_RE = %r{<TITLE>(?<text>.*?)</TITLE>}ixm


## pass 1 - download
pages.each_with_index do |config,i|

## todo / double check fix read_csv upstream
##    if   empty column has comment it is "" empty string otherwise
##                it is nil!!!  ??

  encoding = config['encoding'] 
  encoding = 'windows-1252'   if encoding.nil? || encoding.empty?
  
  page     = config['page']
  url      = "https://rsssf.org/#{page}"

  ## check if not in cache  
  ##   note - use force == true  to always (force) download
 
=begin
  if %w[
tablesj/jpn2025.html
tablesk/kyrg2026.html
tablest/taji2026.html
tablest/turkm2025.html
].include?( page )
=end


  if Webcache.cached?( url ) && opts[:force] == false 
      puts "   CACHE HIT - #{url}"
  else
      puts "==> [#{i+1}/#{pages.size}] download #{config.pretty_inspect}..."
      html = Rsssf.download_page( url, encoding: encoding )

      if encoding == 'windows-1252'
          ## try a quick check if proper encoding
          ## search for title in page
           if  m=TITLE_RE.match( html )
              puts "  page title: #{m[:text].strip}"
           else
             puts "error - no title found in html - encoding error?"
             exit 1
           end
      end
  end
end
  

## pass 2 - convert
pages.each_with_index do |config,i|
  page     = config['page']
  url      = "https://rsssf.org/#{page}"

  html     = Webcache.read( url )
  
  basename = File.basename( page, File.extname( page ))
  dirname  = File.dirname( page )

  puts
  puts "==> [#{i+1}/#{pages.size}] converting #{config.pretty_inspect}......"

  txt = Rsssf::PageConverter.convert( html, url: url )

  write_text( "#{outdir}/#{dirname}/#{basename}.txt", txt )
end


puts "bye"


