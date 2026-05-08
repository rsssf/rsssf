###
##  to run tests use
##   $ ruby  fmtfix/test_headers.rb


## minitest setup
require 'minitest/autorun'

## our own code
$LOAD_PATH.unshift( './rsssf/lib' )
require 'rsssf'



class TestHeaders< Minitest::Test



def test_headers

   fmtfix = Rsssf::Fmtfix.new

  ## norm text
   txt = read_text( "./fmtfix/test_headers.txt" )

   txt = txt.gsub( "\t", '  ' )
   txt = txt.gsub( "\r\n", "\n" )
   ## add smart quotes and unicode minus/hyphen etc.


  txt.each_line do |line|
       line = line.rstrip

        next  if line.match( /^[ ]*$/ ) || line.start_with?( '#')


        ## note - handle_header returns nil if no match
        ##            otherwise the reformatted (new) line !!!

        newline = fmtfix.handle_header( line.rstrip )
        if newline
                   puts "  OK #{newline}"
                   assert true
        else
                   puts "!! header NOT matching - #{line}"
                   assert false
        end
  end
end  # method test_headers
end  # class TestHeaders



puts "bye"
