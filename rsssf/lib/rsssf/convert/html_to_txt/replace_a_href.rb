module Rsssf
class PageConverter

 # <a href="#sa">Série A</a><br>
  # 
  #  <A href="http://www.rsssf.org/">Rec.Sport.Soccer 
  #        Statistics Foundation</A> 
  #  <A href="http://www.rsssfbrasil.com">RSSSF 
  #    Brazil</A> 
  #
  #  and Daniel Dalence (<A
  #   href="mailto:danielballack@terra.com.br">danielballack@terra.com.br</A>)


  A_HREF_RE = %r{<A \s+ HREF [ ]* = 
                    (?<href>[^>]+?)
                  >
                    (?<title>.+?)
                  <\/A>
                }imx              


def replace_a_href( html )
  ## remove anchors (a href)
  #    note: heading 4 includes anchor (thus, let anchors go first)
  #  note: <a \newline href is used for authors email - thus incl. support for newline as space
  html.gsub( A_HREF_RE ) do |match|   ## note: use .+? non-greedy match
    m = Regexp.last_match
    href  = m[:href].gsub( /["']/, '' ).strip   ## remove ("" or '')
    title = m[:title].strip   ## note: "save" caputure first; gets replaced by gsub (next regex call)


    ## e.g.
    ##  ‹Larsen23@gmx.de, see page mailto:Larsen23@gmx.de›
    ##  ‹danielballack@terra.com.br, see page mailto:danielballack@terra.com.br›
    ##  ‹zja70@aol.com, see page mailto:zja70@aol.com›)
    if href.start_with?( 'mailto:')
      puts " blank mailto  -  anchor (a) href >#{href}, >#{title}<"
      '‹mailto›'   ## delete/remove email
    else
      puts " replace anchor (a) href >#{href}, >#{title}<"

      ## convert href to xref
      xref = if href.start_with?('#')    ## in-page ref
              ", see §#{href[1..-1]}"
             elsif href.start_with?( /https?:/ )            ## external page ref
               ## skip - keep empty - why? why not? (or add url domain?)
               ''
             else
               ## hack - check for some custom excludes  
               if title.start_with?( 'Rec.Sport.Soccer' )
                    ## skip - keep empty
                    '' 
               else   
                 ## strip (ending)  .htm|html
                 ", see page #{href.sub( /\.html?$/,'')}"
               end
             end

      "‹#{squish(title)}#{xref}›"
    end
  end
end



end # module PageConverter
end # module Rsssf
