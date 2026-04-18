###
##  to run tests use
##   $ ruby  fmtfix/test_topscorers.rb


## minitest setup
require 'minitest/autorun'

## our own code
require_relative  'fmtfix'



class TestScorers< Minitest::Test

def test_scorers

  ## norm text
   txt = read_text( "./fmtfix/test_topscorers.txt" )
   txt = txt.gsub( "\t", '  ' )
   txt = txt.gsub( "\r\n", "\n" )
   ## add smart quotes and unicode minus/hyphen etc.


   ## not - split in sections  with §
   ##   strips leading & trailing newlines
   ##    auto-adds a trailing newline
   sects = txt.split( %r{^
                            [ ]* § [ ]*
                              \n{1,2}
                         }x )


    sects.each do |sect|
      
        m = TOPSCORERS_RE.match( sect )
        if m && m.offset(0)[0] == 0

            ## check if leftover after table
            footer = sect[m.offset(0)[1]..-1]
            if /\A[ \n]+\z/.match( footer )
              puts "  OK  topscorers >#{m[:header]}<"
              assert true
            else
              puts "!! ERROR - matching topscorers BUT has left over footer; starting at #{m.offset(0)[1]}"
              pp footer
              puts "---"
              pp sect
              assert false
            end
        elsif m 
            puts "!! ERROR - match NOT anchored to begin-of-line; starting at #{m.offset(0)[0]}" 
            pp sect
            assert false
        else 
            puts "!! ERROR - no match"
            pp sect               
            assert false
        end
  end
end  # method test_scorers
end  # class TestScorers



puts "bye"

