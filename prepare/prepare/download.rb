


TITLE_RE = %r{<TITLE>(?<text>.*?)</TITLE>}ixm


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
 
=begin
  if %w[
tablesj/jpn2025.html
tablesk/kyrg2026.html
tablest/taji2026.html
tablest/turkm2025.html
].include?( page )
=end


    if Webcache.cached?( url ) && force == false 
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
end
