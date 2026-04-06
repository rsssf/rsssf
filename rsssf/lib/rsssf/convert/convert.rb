
module Rsssf
class PageConverter
 
    ## convenience helper
     def self.convert( html, url: )
           @@converter ||= new   ## use a "shared" built-in converter
           @@converter.convert( html, url: url )
     end
    
  ##
  ##  add anchor: options or such 
  ##    lets you toggle adding anchors (§premier etc.) - why? why not?  
  
  def convert( html, url: )
    ### todo/fix: first check if html is all ascii-7bit e.g.
    ## includes only chars from 64 to 127!!!
  
    ## normalize newlines
    ##   replace \r\n (form feed \r) used by Windows - ff+lf; 
    ##         just use \n (new line a.k.a. line feed)
    html = html.gsub( "\r\n", "\n" )

    
    html = convert_html_entities( html )

 ###################################
 ### smart quotes quick fixes   
 ### convert all "smart" quote to (standard) single and double quotes
 ##  D´Alessandro   =>  D'Alessandro 
  
    html = html.gsub( /[´’‘]/, "'" )    
    html = html.gsub( /[“”]/,  '"' )

  ### convert fancy (unicode) dashes/hyphens to plain dash/hyphen  
     html = html.gsub( '–', '-' )
 


    txt   = html_to_txt( html, url: url )
  
    header = <<EOS
  <!--
     source: #{url}
    -->
  
EOS
  
    header+txt  ## return txt w/ header
  end  ## method convert

  


###################
# more helpers
def log( msg )
  ## append msg to ./logs.txt  
  ##     use ./errors.txt - why? why not?
  File.open( './logs.txt', 'a:utf-8' ) do |f|
    f.write( msg )
    f.write( "\n" ) 
  end
end



end # module PageConverter
end # module Rsssf

