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
                       (?<title> .+?)
                     </H\k<level>>
                     \s*
                   }imx



  ###
  ##  note - MUST be a one a single line (see make heading for more)   
  ##           e.g.    "<h#{tag}>#{text}</h#{tag}>"              
  BOLD_OR_UNDERLINE_LINE_HEADING_RE = %r{^
                          [ ]*
                     <H (?<tag> [BU]) >
                       (?<title> .+?)
                     </H \k<tag> >
                         [ ]*
                          $
                   }ix
  
                 
  def replace_heading( html )
     html = html.gsub( HEADING_RE ) do |_|
        m = Regexp.last_match

        level = m[:level].to_i(10) 
        title = m[:title]

        puts " replace heading #{level} (h#{level}) >#{title}<"

        ## note: make sure to always add two newlines before and after
        "\n\n#{'='*level} #{title}\n\n"    
        
     end

     html = html.gsub( BOLD_OR_UNDERLINE_LINE_HEADING_RE ) do |_|
        m = Regexp.last_match

        tag = m[:tag].downcase 
        title = m[:title]

        ## use heading 5 for b and heading 6 for underline for now
        ##   maybe later change to custom  ==_ or ==* or such
        ##     to mark the heading (sourced via bold/underscore) ???
        level =  if tag == 'b'
                      5
                 elsif tag == 'u'
                      6 
                 else
                     raise ArgumentError, "b(old)|u(underscore) tag expected; got #{tag}"
                 end

        puts " replace #{tag}-heading #{level} (h#{level}) >#{title}<"

        ## note: do NOT add any newlines before and after
        "#{'='*level} #{title}"    
     end
   
    html
  end


end # module PageConverter
end # module Rsssf
