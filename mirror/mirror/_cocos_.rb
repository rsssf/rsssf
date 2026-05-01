
EDIT_PATH_HEADER_RE = %r{^   [ ]*
                          (?<path> [/a-z0-9._-]+)
                             [ ]*:[ ]*
                           $}ix

EDIT_SUB_CONTINUATION_RE = %r{  [ ]*
                                   =>
                                 [ ]*\n
                               }x

EDIT_SUB_SPLIT_RE = %r{   [ ]*
                              =>
                            [ ]*
                          }x

def parse_edits( txt )

   ### collapse  => with newline into one line
   txt = txt.gsub( "\r\n", "\n")   ## make sure universal newlines
   txt = txt.gsub( EDIT_SUB_CONTINUATION_RE, '  =>  ' )

   edits = {}
   last_path = nil
   txt.each_line do |line|
      line = line.strip
      next  if line.start_with?('#') || line.empty?

      if m=EDIT_PATH_HEADER_RE.match( line )
           last_path = m[:path]
      else
         ## check for substitution rule - search => replace
         parts = line.split( EDIT_SUB_SPLIT_RE, 2 )  ## note - only get max. two parts

         raise ArgumentError, "(path) header for search/replace line required >#{line}<"  if last_path.nil?

         if parts.size == 2
              edits[last_path] ||= []
              edits[last_path] << parts
         else
            raise ArgumentError, "two parts for search/replace line required >#{line}<"
         end
      end
   end

   edits
end

def read_edits( path )  parse_edits(read_text( path )); end
