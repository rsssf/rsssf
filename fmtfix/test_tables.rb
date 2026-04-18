###
##  to run tests use
##   $ ruby  fmtfix/test_tables.rb


## minitest setup
require 'minitest/autorun'

## our own code
require_relative  'fmtfix'



class TestTables< Minitest::Test

def test_headers

  ## norm text
   txt = read_text( "./fmtfix/test_tables.txt" )
   txt = txt.gsub( "\t", '  ' )
   txt = txt.gsub( "\r\n", "\n" )
   ## add smart quotes and unicode minus/hyphen etc.


   ## not - split in sections  with §
   ##   strips leading & trailing newlines
   ##    auto-adds a trailing newline
   tables = txt.split( %r{^
                            [ ]* § [ ]*
                              \n{1,2}
                         }x )


    tables.each_with_index do |table, i|
      
        m = TABLE_RE.match( table )
        if m && m.offset(0)[0] == 0

            ## check if leftover after table
            footer = table[m.offset(0)[1]..-1]
            if /\A[ \n]+\z/.match( footer )
              puts "  OK  table >#{m[:header]}<"
              assert true
            else
              puts "!! ERROR - matching table BUT has left over footer; starting at #{m.offset(0)[1]}"
              pp footer
              puts "---"
              pp table
              assert false
            end
        elsif m 
            puts "!! ERROR - match NOT anchored to begin-of-line; starting at #{m.offset(0)[0]}" 
            pp table
            assert false
        else 
            puts "!! ERROR - no match"
            pp table               
            assert false
        end
  end
end  # method test_headers
end  # class TestTables



puts "bye"

