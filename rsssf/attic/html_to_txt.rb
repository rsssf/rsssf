
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