
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


    ## note - expand tabs inside pre blocks only - why? why not?
    ##            otherwise if any left replace tabs with space

    if html.include?( "\t" )
      html =  html.gsub( %r{
                              (<PRE \b [^>]*>)
                                (.*?)    ## note - non-greedy match
                              (<\/PRE>)
                          }ixm) do

                            ### note - tabstops usage not a "legacy"
                            ##          still used in latest pages!!!
                            ### log( "found tabs in pre blocks in <#{url}>; expand w/ tabstop length 8")

                            m = Regexp.last_match
                            open_tag  = m[1]
                            content   = m[2]
                            close_tag = m[3]

                            expanded = _expand_tabs( content, tabsize:8 )
                            open_tag + expanded + close_tag
                     end

       if html.include?( "\t" )
         ##  todo -  report/log tabs outside of pre blocks!!!
         ## convert tabs to two spaces (or use four??)
         log( "found tabs in non-pre blocks in <#{url}>; replace w/ two spaces")
         html = html.gsub( "\t", '  ' )
       end
    end




    html = convert_html_entities( html, url: url )


 ###################################
 ### smart quotes quick fixes
 ### convert all "smart" quote to (standard) single and double quotes
 ##  D´Alessandro   =>  D'Alessandro
 ##    81´ and 88'   =>  81' and 88'


    html = html.gsub( /[´’‘]/, "'" )
    html = html.gsub( /[“”]/,  '"' )

  ### convert fancy (unicode) dashes/hyphens to plain dash/hyphen
     html = html.gsub( '–', '-' )



    txt   = html_to_txt( html, url: url )
    txt
  end  ## method convert



  def _expand_tabs(txt, tabsize:)
    col = 0

    buf = String.new
    txt.each_char do |ch|
      if ch == "\n"
        col = 0
        buf << ch
      elsif ch == "\t"
        spaces = tabsize - (col % tabsize)
        col += spaces
        buf <<  " " * spaces
      else
        col += 1
        buf << ch
      end
    end
    buf
  end



###################
# more helpers
def self.log( msg )
  ## append msg to ./logs.txt
  ##     use ./errors.txt - why? why not?
  File.open( './logs.txt', 'a:utf-8' ) do |f|
    f.write( msg )
    f.write( "\n" )
  end
end
def log( msg ) self.class.log( msg ); end



end # module PageConverter
end # module Rsssf
