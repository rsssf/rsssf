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


  html = html.sub( /.+?
                      <BODY [^>]*? >
                      \s*
                   /xim, 
                   '' )


  ## cut off everything after body (closing)
  html = html.sub( /<\/BODY>.*/im, '' )

  
  ## quick fix
  ## <title>World Cup 1950 qualifications</title>
  ## <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-2">
  
  ## remove title and meta
  html = html.sub( /<TITLE>.*?<\/TITLE>/i, '' )
  html = html.sub( /<META .*?>/i, '' )




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



  ## quick fix
  ##   <H1>Quarterfinals</H2>
  html = html.gsub( '<H1>Quarterfinals</H2>', '<H2>Quarterfinals</H2>' ) 

  html = replace_heading( html )


  ## remove i(talics)
  ##    use non-greedy match as default? e.g. .*? - why? why not?
 
  html = html.gsub( /<I>([^<]+)<\/I>/im ) do |_|
    puts " remove italic (i) >#{$1}<"
    "#{$1}"
  end

  ## quick fix
  ## <M>MEX</B>,  <N>CZE</B>
  ##  change <M>,<N> to <B>
  html = html.gsub( '<M>MEX</B>', '<B>MEX</B>' ) 
  html = html.gsub( '<N>CZE</B>', '<B>CZE</B>' ) 


  ## remove b   - note: might include anchors (thus, call after anchors)
  ###   use non-greedy match as default? e.g. .*? - why? why not?
  html = html.gsub( /<B>([^<]+)<\/B>/im ) do |_|
    puts " remove bold (b) >#{$1}<"
    ## "**#{$1}**"
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


## beautify 
##  ‹§2fin›
##
## == Semifinals
##
##  merge anchor (a name) with heading into one line e.g.
##       => 
##  == Semifinals  ‹§2fin›

   html = html.gsub( /\s*
                          (?<name>‹§
                                    [^›]+?
                                 ›)
                      \s*
                          (?<heading>={2,}
                              [^=\n]+? 
                          )
                       \n
                       \s*/ixm ) do |match|
   
           m = Regexp.last_match
 
           match = match.gsub( "\n", '$$' )  ## make newlines visible for debugging
           puts "   mergeing anchor (a name) with heading into one line - >#{match}<" 

           "\n\n#{m[:heading]}  #{m[:name]}\n\n"
    end

###
## 
## beautify 
##  ‹§argsquad›Argentine Squad Full Info
##  ‹§eng›ENGLAND
##
##
##  reformat anchor (a name) start line with text  e.g.
##       => 
##  Argentine Squad Full Info  ‹§argsquad›
##  ENGLAND  ‹§eng›

   html = html.gsub( /\n
                          (?<name>‹§
                                    [^›]+?
                                 ›)
                      [ ]*
                          (?<text>[^\n]+? 
                          )
                       \n
                       /ixm ) do |match|
   
           m = Regexp.last_match
 
           match = match.gsub( "\n", '$$' )  ## make newlines visible for debugging
           puts "   move anchor (a name) starting line with text to end - >#{match}<"

           "\n#{m[:text]}  #{m[:name]}\n"
    end

###
## beautify heading
##   ==== ‹§gra›Group A
##     =>
##   ==== Group A  ‹§gra›

   html = html.gsub( /\n
                          (?<heading_marker>
                               ={2,})
                               [ ]*
                          (?<name>‹§
                                    [^›]+?
                                 ›)
                             [ ]*
                          (?<heading_text>[^\n]+? 
                          )
                       \n
                       /ixm ) do |match|
   
           m = Regexp.last_match
 
           match = match.gsub( "\n", '$$' )  ## make newlines visible for debugging
           puts "   move anchor (a name) in heading to end - >#{match}<"

           "\n#{m[:heading_marker]} #{m[:heading_text]}  #{m[:name]}\n"
    end



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

  txt
end # method html_to_text



end # module PageConverter
end # module Rsssf
