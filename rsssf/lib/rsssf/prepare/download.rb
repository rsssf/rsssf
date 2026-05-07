
module Rsssf
class  Prep   ## todo: find a better name e.g. BatchPrep or ??


## convenience helper
def self.download_pages( pages, force: )
   @@prep ||= new   ## use a "shared" built-in prep
   @@prep.download_pages( pages, force: force )
end


def download_pages( pages, force: )
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
    if Webcache.cached?( url ) && force == false
        puts "   CACHE HIT - #{url}"
    else
        puts "==> [#{i+1}/#{pages.size}] download #{config.pretty_inspect}..."
        html = Rsssf.download_page( url, encoding: encoding )
    end
  end
end


end    ## class Prep
end    ## module Rsssf