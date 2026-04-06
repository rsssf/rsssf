module Rsssf
class PageConverter


  # <a name="sa">Série A</a>
  # <a name="sd">Série D</a> 

  # <A name=about>
  #  <H2>About this document</H2></A>
  #   => change to (possible?)
  #  <H2><A name=about>About this document</A></H2>
  #
  #
  # <h4><a name="cb">Copa do Brasil</a></h4>

   ## note  - for content use non-greedy to allow 
   ##              match of tags inside content too

  A_NAME_OLD_RE = %r{<A [ ]+ NAME [ ]* =
                     (?<name>[^>]+?) 
                  >
                     (?<title>.+?) 
                  </A>
                }imx


  A_NAME_RE = %r{<A [ ]+ NAME [ ]* =
                     (?<name>[^>]+?) 
                  >
                }imx

                
def replace_a_name_old( html )
  ##
  ## remove (named) anchors
  html.gsub( A_NAME_RE ) do |match|   ## note: use .+? non-greedy match
    m = Regexp.last_match
    name = m[:name].gsub( /["']/, '' ).strip   ## remove ("" or '')
    title = m[:title].strip   ## note: "save" caputure first; gets replaced by gsub (next regex call)
    match = match.gsub( "\n", '$$' )  ## make newlines visible for debugging
    puts " replace anchor (a) name >#{name}<, >#{title}<    -    >#{match}<"
  

   ##
   ## todo - report WARN if title incl. tags
   ##    assumes text only for now - why? why not?
   ##  add a name inside heading !!!
   ##  do NOT add heading inside a name !!!

    "#{title}  ‹§#{name}›"   ## note - use two spaces min (between title & name)
  end
end



def replace_a_name( html )

  ## note - allows <a name=""> without closing </a>
  ##    <a name="semi"><H2>Semifinals</H2>
  ##   always put anchor on its own line for now

  ##
  ## remove (named) anchors
  html.gsub( A_NAME_RE ) do |match|   ## note: use .+? non-greedy match
    m = Regexp.last_match
    
    name = m[:name].gsub( /["']/, '' ).strip   ## remove ("" or '')
    match = match.gsub( "\n", '$$' )  ## make newlines visible for debugging
    puts " replace anchor (a) name >#{name}<    -    >#{match}<"
  
   ##
   ## todo - report WARN if title incl. tags
   ##    assumes text only for now - why? why not?
   ##  add a name inside heading !!!
   ##  do NOT add heading inside a name !!!

    "‹§#{name}›"   ## note - use two spaces min (between title & name)
  end
end




end # module PageConverter
end # module Rsssf


