module Rsssf
class PageConverter


  ## note - for h1,h2,h3,h4,h5,h6
  ##     use a backref(erence) e.g. \1
  ##
  ## note - include leading and trailing spaces (incl. newlines) !!!
  ##
  ## note  - for content inside use non-greedy to allow 
  ##              match of tags inside content too
  HEADING_RE = %r{ \s*
                     <H(?<level>[1-6])>
                       (?<title>.+?)
                     </H\k<level>>
                     \s*
                   }imx

  
                 
  def replace_heading( html )
     html.gsub( HEADING_RE ) do |_|
        m = Regexp.last_match

        level = m[:level].to_i(10) 
        title = m[:title]

        puts " replace heading #{level} (h#{level}) >#{title}<"

        ## note: make sure to always add two newlines before and after
        "\n\n#{'='*level} #{title}\n\n"    
        
     end
  end




end # module PageConverter
end # module Rsssf
