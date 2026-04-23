

TITLE_RE = %r{
    <TITLE>(?<text>.*?)</TITLE>
}ixm


def _download_page( url, encoding:,
                         force: )


  ## check if not in cache
  ##   note - use force == true  to always (force) download
    html = nil


    if Webcache.cached?( url ) && force == false
        puts "   CACHE HIT - #{url}"
        html = Webcache.read( url )
        [html, true]
    else
        puts "==> download #{url} (encoding: #{encoding})..."


    ## note: assume plain 7-bit ascii for now
    ##  -- assume rsssf uses ISO_8859_15 (updated version of ISO_8859_1)
    ###-- does NOT use utf-8 character encoding!!!
    response = Webget.page( url, encoding: encoding )  ## fetch (and cache) html page (via HTTP GET)

    ## note: exit on get / fetch error - do NOT continue for now - why? why not?
    exit 1   if response.status.nok?    ## e.g.  HTTP status code != 200

    puts "html:"
    html =  response.text( encoding: encoding )
    pp html[0..200]
    html


=begin
https://rsssf.org/miscellaneous/ec-qual.html

min - page with no title   uses <head/> !!!
e.g
<html>
<head/><pre>
Contributed by ...
</pre>
</html>



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
=end



        [html,false]
    end

end
