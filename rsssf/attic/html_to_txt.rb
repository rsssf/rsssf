
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




def patch_about( html )
  # <A name=about>
  #  <H2>About this document</H2></A> 
  #  or
  # <A NAME="about"><H2>About this document</H2></A>
  #   => change to (possible?)
  #  <H2><A name=about>About this document</A></H2>

   html.sub( %r{<A [ ] name=(about|"about")> \s*
              <H2>About [ ] this [ ] document</H2></A>
             }ixm,
              "<H2><A name=about>About this document</A></H2>"
            )
end


def html_to_text

 html = replace_a_href( html )
  ##  note a name="about" includes more a hrefs etc.
  #    let it go first (before a href)
  html = replace_a_name( html )

end