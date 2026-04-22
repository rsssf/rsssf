

## use workdir or rootdir or such - why? why not?

## add later e.g.  exclude_edits: true,
#                  exclude_about: true
def collect_datafiles( *globs, dir: )

   ###
   ## note - auto-add  /**/*.txt to globs!!!

   files = []
   globs.each do |glob|
      Dir.chdir( dir) do
        more_files =  Dir.glob( "#{glob}/**/*.txt" )

##
## note - auto-exclude/ignore ALWAYS for now
##      .edits.txt !!!
##   e.g. br2026.edits.txt and such
##

  more_files = more_files.select do |file|
             if File.basename( file ).downcase.end_with?( '.edits.txt') ||
                File.basename( file ).downcase.end_with?( '.links.txt') ||
                File.basename( file ).downcase.end_with?( '.about.txt')
                 false
             else
                 true
             end
        end

        exclude_edits = true
        exclude_links = true
        exclude_about = true

        puts "==> #{glob}/**/*.txt  (exclude_edits: #{exclude_edits}, exclude_links: #{exclude_links}, exclude_about: #{exclude_about})"
        puts "  #{more_files.size} file(s)"
        files += more_files
     end
   end
   files
end
