module Rsssf
class Page


###
#  (experimental)
#  machinery to split document by leagues & cups



LEAGUE_ROUND_REGEX = /\b
                      Round
                      \b/ix

CUP_ROUND_REGEX  = /\b(
                      Round         |
                      1\/8\sFinals  |
                      1\/16\sFinals |
                      Quarterfinals |
                      Semifinals    |
                      Final
                    )\b/ix



## make header required - why? why not?
def find_schedule( header: nil,
                   cup:    false )     ## change to build_schedule - why? why not???

  ## find match schedule/fixtures in multi-league doc
  new_txt = String.new

  ## note: keep track of statistics
  ##   e.g. number of rounds found

  round_count = 0

  if header
    league_header_found        = false

     ## header:
     ##  - assumes heading 4 e.g. #### Premier League or
     ##  - bold e.g. **FA Cup** for now
     ##  note: markers must start line (^)

     ## note:
     ## header gsub spaces to \s otherwise no match in regex (using free-form x-flag)!!!
     header_esc   = header.gsub( ' ', '\s' )

     ## note: somehow #{2,4} will not work with free-form /xi defined (picked up as comment?)
     ##  use [#] hack ??
     header_regex = /^
                      ([#]{2,4}\s+(#{header_esc}))
                        |
                      (\*{2}(#{header_esc}))     ## was: \*{2})
                                                 ##  do not inluce trailing ** for now (allows anchors e.g. §)
                    /ix

    ## todo:
    ##   use new stage_regex e.g. **xxx** - why? why not?
    ##  allow more than one stage in one schedule (e.g. regular stage,playoff stage etc)

  else
    league_header_found = true   # default (no header; assume single league file)
    header_regex = /^---dummy---$/  ## non-matching dummy regex
  end

  ## puts "header_regex:"
  ## pp header_regex


  if cup
    round_regex = CUP_ROUND_REGEX   ## note: only allow final, quaterfinals, etc. if knockout cup
  else
    round_regex = LEAGUE_ROUND_REGEX
  end


  ## stages
  first_round_header_found   = false
  round_header_found         = false
  round_body_found           = false   ## allow round header followed by blank lines

  blank_found = false



  @txt.each_line do |line|

    if league_header_found == false
      ## first find start of league header/section
      if line =~ header_regex
        puts "!!! bingo - found header >#{line}<"
        league_header_found = true

        ## note - do NOT auto-add header/title !!!
        # title = line.gsub( /[#*]/, '' ).strip   ##  quick hack: extract title from header
        # new_txt << "## #{title}\n\n"    # note: use header/stage title (regex group capture)
      else
        puts "  searching for header >#{header}<; skipping line >#{line}<"
        next
      end
    elsif first_round_header_found == false
      ## next look for first round (starting w/ Round)
      if line =~ round_regex
        puts "!!! bingo - found first round >#{line}<"
        round_count += 1
        first_round_header_found = true
        round_header_found       = true
        round_body_found         = false
        new_txt << line
      elsif line =~ /^=-=-=-=/
        puts "*** no rounds found; hit section marker (horizontal rule)"
        break
      elsif line =~ /^\*{2}[^*]+\*{2}/   ## e.g. **FA Cup**
        puts "*** no rounds found; hit section/stage header: #{line}"
        break
      else
        puts "  searching for first round; skipping line >#{line}<"
        next ## continue; searching
      end
    elsif round_header_found == true
      ## collect rounds;
      ##   assume text block until next blank line
      ##   new block must allways start w/ round
      if line =~ /^\s*$/   ## blank line?
        if round_body_found
          round_header_found = false
          blank_found        = true    ## keep track of blank (lines) - allow inside round block (can continue w/ date header/marker)
          new_txt << line
        else
          ## note: skip blanks following header
          next
        end
      else
        round_body_found = true
        new_txt << line   ## keep going until next blank line
      end
    else
      ## skip (more) blank lines
      if line =~ /^\s*$/
        next  ## continue; skip extra blank line
      elsif line =~ round_regex
        puts "!!! bingo - found new round >#{line}<"
        round_count += 1
        round_header_found = true   # more rounds; continue
        round_body_found   = false
        blank_found        = false  # reset blank tracker
        new_txt << line
      elsif blank_found && line =~ /\[[a-z]{3} \d{1,2}\]/i   ## e.g. [Mar 13] or [May 5] with leading blank line; continue round
        puts "!!! bingo - continue round >#{line}<"
        round_header_found = true
        blank_found        = false  # reset blank tracker
        new_txt << line
      elsif blank_found && line =~ /First Legs|Second Legs/i
        puts "!!! bingo - continue round >#{line}<"
        round_header_found = true
        blank_found        = false  # reset blank tracker
        new_txt << line
      elsif line =~ /=-=-=-=/
        puts "!!! stop schedule; hit section marker (horizontal rule)"
        break;
      elsif line =~ /^\*{2}[^*]+\*{2}/   ## e.g. **FA Cup**
        puts "!!! stop schedule; hit section/stage header: #{line}"
        break
      else
        blank_found  = false
        puts "skipping line in schedule >#{line}<"
        next # continue
      end
    end
  end  # each line


  ## quick hack?
  ### auto-apply patch if patch configured
   if @patch  && @patch.respond_to?(:on_patch)
      url_path = URI.parse( url ).path
      basename = File.basename( url_path, File.extname( url_path ))
      year     = year_from_name( basename )
      new_txt = @patch.on_patch( new_txt, basename, year )
   end

  schedule = Schedule.new( new_txt )
  ## schedule.rounds = round_count

  schedule
end  # method find_schedule



end # class Page
end # module Rsssf