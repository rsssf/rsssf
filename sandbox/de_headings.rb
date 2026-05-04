
module PatchDe

## e.g. 2008/09
##   note: also support 1999/2000
SEASON = '\d{4}\/(\d{2}|\d{4})'  ## note: use single quotes - quotes do NOT get escaped (e.g. '\d' => "\\d")



DE_BUNDESLIGA1 = [
  ## e.g. 1.Bundesliga or
  ##      1. Bundesliga
   %r{^  1\.[ ]?Bundesliga   $}x,
]

DE_BUNDESLIGA2 = [
  ## e.g. Second Level 2008/09   $$
  ##      2.Bundesliga
  %r{^   Second [ ] Level [ ] #{SEASON} \s+
     ^   2\.[ ]? Bundesliga  $},
  ## e.g. 2.Bundesliga or 2. Bundesliga
  /^2\.( )?Bundesliga$/,
  ## e.g. Germany 1998/99  2.Bundesliga
  /^Germany #{SEASON}\s+2\.( )?Bundesliga$/,
]


DE_LIGA3 = [
  ## e.g. Third Level 2008/09   $$
  ##      3.Bundesliga
  /^Third Level #{SEASON}\s+^3\.( )?Bundesliga$/,
]



DE_CUP = [
  ## e.g. Germany Cup (DFB Pokal) 1998/99
  /^Germany Cup \(DFB Pokal\) #{SEASON}$/,
  ## e.g. DFB Pokal 2008/09 or DFB-Pokal 1996/97
  /^DFB[ -]Pokal #{SEASON}$/,
  ## e.g. DFB-Pokal or DFB Pokal
  /^DFB[ -]Pokal$/,
  ## e.g. Cup 2006/07
  /^Cup #{SEASON}$/,
]




def self._patch_heading( txt, rxs, title )
  rxs.each do |rx|
    txt = txt.sub( rx ) do |match|
      match = match.gsub( "\n", '$$')  ## change newlines to $$ for single-line outputs/dumps
      puts "  found heading >#{match}<"
      "\n== #{title}\n\n"
    end
  end
  txt
end

### pass along page (obj) instead of txt - why? why not?



  def on_prepare( txt, name, year )

    if year < 2010   # note: duit2010 starts a new format w/ heading 4 sections etc.
      ##  puts "  format -- year < 2010"
      ## try to add section header (marker)

      txt = patch_heading( txt, DE_BUNDESLIGA1, '1. Bundesliga' )
      txt = patch_heading( txt, DE_BUNDESLIGA2, '2. Bundesliga' )
      txt = patch_heading( txt, DE_LIGA3,       '3. Liga'       )
      txt = patch_heading( txt, DE_CUP,         'DFB Pokal'     )
    end # year < 2010
     txt
  end
