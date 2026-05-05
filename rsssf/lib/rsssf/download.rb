
module Rsssf

  def self.download_page( url, encoding: )

    ## note: assume plain 7-bit ascii for now
    ##  -- assume rsssf uses ISO_8859_15 (updated version of ISO_8859_1)
    ###-- does NOT use utf-8 character encoding!!!
    response = Webget.page( url, encoding: encoding )  ## fetch (and cache) html page (via HTTP GET)

    ## note: exit on get / fetch error - do NOT continue for now - why? why not?
    exit 1   if response.status.nok?    ## e.g.  HTTP status code != 200


    puts "html:"
    html =  response.text( encoding: encoding )
    pp html[0..400]
    html
  end
end  # module Rsssf
