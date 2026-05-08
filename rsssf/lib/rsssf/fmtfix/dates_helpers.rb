module Rsssf
class  Fmtfix


### todo/fix
##    make more (re)usable instead of copy-n-paste here


def self.parse_names( txt )
  lines = [] # array of lines (with words)

  txt.each_line do |line|
    line = line.strip

    next if line.empty?
    next if line.start_with?( '#' )   ## skip comments too

    ## strip inline (until end-of-line) comments too
    ##   e.g. Janvier  Janv  Jan  ## check janv in use??
    ##   =>   Janvier  Janv  Jan

    line = line.sub( /#.*/, '' ).strip
    ## pp line

    values = line.split( /[ \t]+/ )
    ## pp values

    ## todo/fix -- add check for duplicates
    lines << values
  end
  lines

end # method parse


def self.build_names( lines )
  ## join all words together into a single string e.g.
  ##   January|Jan|February|Feb|March|Mar|April|Apr|May|June|Jun|...
  lines.map { |line| line.join('|') }.join('|')
end


def self.build_map( lines,
               downcase: false )
   ## note: downcase name!!!
  ## build a lookup map that maps the word to the index (line no) plus 1 e.g.
  ##  {"january" => 1,  "jan" => 1,
  ##   "february" => 2, "feb" => 2,
  ##   "march" => 3,    "mar" => 3,
  ##   "april" => 4,    "apr" => 4,
  ##   "may" => 5,
  ##   "june" => 6,     "jun" => 6, ...
  lines.each_with_index.reduce( {} ) do |h,(line,i)|
    line.each do |name|
       h[ downcase ? name.downcase : name ] = i+1
    end  ## note: start mapping with 1 (and NOT zero-based, that is, 0)
    h
  end
end


end    ## class Fmtfix
end    ## module Rsssf
