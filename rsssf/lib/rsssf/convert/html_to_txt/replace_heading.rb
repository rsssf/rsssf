module Rsssf
class PageConverter


  ## todo/fix - use generic heading regex for all h2/h3/h4 etc.
  ##  exclude h1 - why? why not?
  ## note - include leading and trailing spaces !!!
  ##
  ## note  - for content use non-greedy to allow 
  ##              match of tags inside content too
  HEADING1_RE = %r{ \s*
                     <H1>
                       (?<title>.+?)
                     </H1>
                     \s*
                   }imx

  HEADING2_RE = %r{ \s*
                     <H2>
                       (?<title>.+?)
                     </H2>
                     \s*
                   }imx
                   
  HEADING4_RE = %r{ \s*
                   <H4>
                     (?<title>.+?)
                   </H4>
                   \s*
                 }imx

                 
  def replace_h1( html )
     html.gsub( HEADING1_RE ) do |_|
        m = Regexp.last_match
        puts " replace heading 1 (h1) >#{m[:title]}<"
        "\n\n= #{m[:title]}\n\n"    ## note: make sure to always add two newlines
     end
  end


  def replace_h2( html )
     html.gsub( HEADING2_RE ) do |_|
        m = Regexp.last_match
        puts " replace heading 2 (h2) >#{m[:title]}<"
        "\n\n== #{m[:title]}\n\n"    ## note: make sure to always add two newlines
     end
  end


  def replace_h4( html )
    html.gsub( HEADING4_RE ) do |_|
       m = Regexp.last_match
       puts " replace heading 4 (h4) >#{m[:title]}<"
       "\n\n==== #{m[:title]}\n\n"    ## note: make sure to always add two newlines
    end
 end


end # module PageConverter
end # module Rsssf
