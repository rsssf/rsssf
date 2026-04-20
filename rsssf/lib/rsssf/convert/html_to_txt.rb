module Rsssf
class PageConverter






 def squish( str )
    ## squish more than one white space to one space
    str.gsub( /[ \r\t\n]+/, ' ' )
 end




def html_to_txt( html, url: )

###
#   todo: check if any tags (still) present??


  ## cut off everything before body
  ##   
  ## note - might incl. attributes e.g.
  ## <body bgcolor="yellow">

  ## record / track (important) edits - sub(stitutions) etc.
  edits = []


  html = html.sub( /.+?
                      <BODY [^>]*? >
                      \s*
                   /xim, 
                   '' )
                  
  ## special case i)   no <body> - cut-off head if present
  ## cut off everything before <head/>
  ##   used in braz93.html, braz98.html
  html = html.sub( /.+?
                     <\/HEAD>
                       \s*
                   /xim, '' )    

  ## special case ii) no <body>, no </head> 
  ## cut off everything before <head/>
  ##   used in braz93.html, braz98.html
  html = html.sub( /.+?
                     <HEAD\/>
                       \s*
                   /xim, '' )    




  ## cut off everything after body (closing)
  html = html.sub( /<\/BODY>.*/im, '' )
  
  ## special case
  ## cut off everything after </html> (closing)
  ##   used in braz93.html, braz98.html
  html = html.sub( /<\/HTML>.*/im, '' )




  ## quick fix
  ## <title>World Cup 1950 qualifications</title>
  ## <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-2">
  
  ## remove title and meta
  html = html.sub( /<TITLE>.*?<\/TITLE>/i, '' )
  html = html.sub( /<META .*?>/i, '' )


  ## (auto-)fix known types / errors
  ##  todo - pass in/along filename/url too - why? why not?
  html = errata_html( html )



  ##
  ##   change ^<b><a name ...></a></b>$  or    <hb>  - heading "bold" - might be h5
  ##          ^<u><a name ...></a></u>$    to  <hu>  - heading "underscore" - might be h6
  html, more_edits = make_heading( html )
  edits += more_edits 






  ## remove cite
  html = html.gsub( /<CITE>([^<]+)<\/CITE>/im ) do |_|
    puts " remove cite >#{$1}<"
    "#{$1}"
  end


  html = replace_hr( html )




  ## replace break (br)
  ## note: do NOT use m/multiline for now - why? why not??
  html = html.gsub( /<BR>\s*/i ) do |match|    ## note: include (swallow) "extra" newline
    match = match.gsub( "\n", '$$' )  ## make newlines visible for debugging
    puts " replace break (br) - >#{match}<"
    "\n"
  end



  
  html = replace_a_name( html )

  html = replace_a_href( html )

  ## quickfix  remove trailing </a> left possibly by a_name
  html = html.gsub( /<\/A>/i, '' )



  ## replace paragrah (p)
  html = html.gsub( /\s*<P>\s*/im ) do |match|    ## note: include (swallow) "extra" newline
    match = match.gsub( "\n", '$$' )  ## make newlines visible for debugging
    puts " replace paragraph (p) - >#{match}<"
    "\n\n"
  end
  html = html.gsub( /<\/P>/i, '' )  ## replace paragraph (p) closing w/ nothing for now



 
  html = replace_heading( html )


  ## remove i(talics)
  ##    use non-greedy match as default? e.g. .*? - why? why not?
  ##    or greedy w/  ([^<]+)
  html = html.gsub( /<I>(.*?)<\/I>/im ) do |_|
    puts " remove italic (i) >#{$1}<"
    "#{$1}"
  end

  html = html.gsub( /<U>(.*?)<\/U>/im ) do |_|
    puts " remove underline (u) >#{$1}<"
    "#{$1}"
  end

  ## remove b   - note: might include anchors (thus, call after anchors)
  ###   use non-greedy match as default? e.g. .*? - why? why not?
  ## was - "**#{$1}**"
  html = html.gsub( /<B>(.*?)<\/B>/im ) do |_|
    puts " remove bold (b) >#{$1}<"
    "#{$1}"  
  end

  ## <strong></strong>
  html = html.gsub( /<STRONG>(.*?)<\/STRONG>/im ) do |_|
    puts " remove strong (strong) >#{$1}<"
    "#{$1}"  
  end



  ## replace preformatted (pre)
  html = html.gsub( /<PRE>|<\/PRE>/i ) do |match|
    puts " replace preformatted (pre)"

      ## note - replace preformatted blocks
      ##           with comments 
      ##  was:
      ##  ''  # replace w/ nothing for now (keep surrounding newlines)
      
     if match.downcase == '<pre>'
         '<!-- start pre -->'
     else
         '<!-- end pre -->'
     end
  end


=begin
  puts
  puts
  puts "html:"
  puts html[0..2000]
  puts "-- snip --"
  puts html[-1000..-1]   ## print last hundred chars
=end


  html = remove_emails( html )


  html = beautify_anchors( html )


  ## check for html tags
  ##  left
  ##  use scan instead of 
  html.gsub( /<
                \/?
                [A-Z]+ [^>]*
              > 
             /xim ) do |match|

          if ['<menu>', '<ul>', '<li>',
               '</menu>', '</ul>', '</li>'].include?(match.downcase) 
               ## do nothing
          else 
                  msg = "found unprocessed html tag #{match} in >#{url}<"
                  puts "*** WARN - #{msg}"
                  log( msg )  ## log too (see log.txt)
          end 
          match
    end


  ##
  ## todo/fix
  ##    move up-front - kind of preprocessing (not post) - why? why not?

  ## cleanup whitespaces
  ##   todo/fix:  convert newline in space first
  ##                and than collapse spaces etc.!!!
  txt = String.new
  html.each_line do |line|
     line = line.gsub( "\t", '  ' ) # replace all tabs w/ two spaces for nwo
     line = line.rstrip             # remove trailing whitespace (incl. newline/formfeed)

     txt << line
     txt << "\n"
  end

  txt = errata_txt( txt )

  [txt, edits]
end # method html_to_text



end # module PageConverter
end # module Rsssf
