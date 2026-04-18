###
##  to run tests use
##   $ ruby  fmtfix/test_headers.rb


## minitest setup
require 'minitest/autorun'

## our own code
require_relative  'fmtfix'



class TestHeaders< Minitest::Test




def xxx_test_dates
   m=HEADER_DATE_II_RE.match( 'Aug 7 1999' )
   pp HEADER_DATE_II_RE
   pp m

   assert m
end



def test_headers

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
      
        newline = handle_header( line.rstrip )
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

