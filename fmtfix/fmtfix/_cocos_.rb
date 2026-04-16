###
##  move "upstream" to cocos for sharing


##
## note - use File.file? instead of File.exist? 
##            (checks if file exists AND file is a file NOT a directory)


def find_file( name, path: )
    return name    if File.file?( name )

    path.each do |dir|
        filepath = File.join( dir, name )
        return filepath   if File.file?(  filepath )
    end

    ## fix/fix/fix - raise exception here
    ##    check for std ruby filenotfound exception (or use argument/valueerror??) !!!!
    puts "!! ERROR - file <#{name}> not found; looking in path: #{path.inspect}"
    exit 1
end



####
#  parse/find_patterns

## use/rename to VARDEF_LINE or such - why? why not?
VARDEF_RE = %r{\A 
                [ ]* 
              \$(?<key> [a-z][a-z0-9_]*) 
                [ ]*
              =
                [ ]*
              (?<value> .+?)   ## eat-up (non-greedy) the rest until end-of-line 
                [ ]*
              \z 
}ix 

VAR_RE = %r{  \$(?<key> [a-z][a-z0-9_]*)
                  \b
}ix




def read_patterns( path ) 
    parse_patterns( read_text( path ))  
end    

def parse_patterns( txt )
 
     ## norm newline (windows cr/lf \r\n) to (lf - \n)
     txt = txt.gsub( /\r\n/, "\n" )  
     
     ### check for line continuations with backslash (\)
     ##      note - allow spaces before newline
     txt = txt.gsub( /\\[ ]*$\n/, '' )


     vars = {}
     names = [] # array of lines (with words)
     txt.each_line do |line|
       line = line.strip

       next if line.empty?
       next if line.start_with?( '#' )   ## skip comments too

       break if line == '__END__'

       ## strip inline (until end-of-line) comments too
       ##   e.g. Janvier  Janv  Jan  ## check janv in use??
       ##   =>   Janvier  Janv  Jan

       line = line.sub( /#.*/, '' ).strip
       ## pp line

       ###
       ##  check for variable defs
       if m = VARDEF_RE.match( line )
           vars[ m[:key].downcase ] = m[:value ]
           next
       end
   
       line = line.gsub( VAR_RE ) do |_|
                  m = Regexp.last_match
                  key = m[:key].downcase

                  value = vars[key]
                  raise ArgumentError, "subvars - no vardef found for key >#{key}<"   if value.nil?
                  value
             end
     
        ### use squish  - remove more than one inline space
         line = line.gsub( /[ ]{2,}/, ' ' )


         ## open paren (use for grouping to non-capture grouping) e.g.
         ##   () => (?: )
         ##   note - do NOT replace escaped /( !!!
         ##         e.g.   playoffs (liguilla)
          line = line.gsub( /  ## negative lookbehind
                                   (?<! \\)
                                \(
                               /x, '(?: ')

         ## expand space shortcuts
         ##     replace  Middle Dot (·)  Unicode: U+00B7 or
         ##             White Square (□)  Unicode: U+25A1 or
         ##   White Small Square     (▫)   Unicode: U+25AB 
         ##               Open Box (␣)    Unicode: U+2423 or
         ##
         ##  add more - why? why not?


          line = line.gsub( /[·□▫␣]/, ' [ ] ' )


       names << line
     end
     names
end






