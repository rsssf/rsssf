###
##  to run tests use
##   $ ruby  fmtfix/test_table_headers.rb


## minitest setup
require 'minitest/autorun'

## our own code
require_relative  'fmtfix'



class TestTableHeaders< Minitest::Test


def test_headers

  ## norm text
   txt = read_text( "./fmtfix/test_table_headers.txt" )
   txt = txt.gsub( "\t", '  ' )
   txt = txt.gsub( "\r\n", "\n" )
   ## add smart quotes and unicode minus/hyphen etc.


    txt.each_line do |line|
      line = line.strip
      next if line.empty? || line.start_with?('#')

        m = TABLE_HEADER_RE.match( line )
        if m && m.offset(0)[0] == 0
            puts "  OK  table header >#{m[0]}<  -  >#{line}<"

## double check positive lookaheads
             if mm = %r{.* (\p{L})}x.match( m[0] )
                puts "    OK  check alpha >#{m[1]}<"
             else
                puts "    !!  check alpha failed on >#{m[0]}<"
             end

            assert true
        elsif m
            puts "!! ERROR - match NOT anchored to begin-of-line; starting at #{m.offset(0)[0]}"
            pp line
            assert false
        else
            puts "!! ERROR - no match"
            pp line
            assert false
        end
  end
end  # method test_headers
end  # class TestTableHeaders



puts "bye"
