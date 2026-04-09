module Rsssf
class PageConverter


def beautify_anchors( html )
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
    html
end


end # module PageConverter
end # module Rsssf

