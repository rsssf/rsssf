

def autofix( txt )

###
##  step 1
##   split by horizontal rules (hrs)
##       and remove navigations sections
##             starting with links e.g.   
## ‹Bundesliga, see §bund›

   sects = txt.split( /^=-=-=-=-=-=-=-=-=-=-=-=-=-=-=$/ )

   
   sects = sects.select do |sect|
      nav = %r{\A
               [ \n]*    ## trailing spaces or blank lines 
                ‹.+?›    ##  link
             }ix.match(sect)
        if nav
           puts "  removing nav(igation section:"
           puts sect
        end     
      nav ? false : true
    end

   ## sects.each_with_index do |sect,i|
   ##  puts "==> #{i+1}/#{sects.size}"
   ##  pp sect
   ## end
   ##  puts "  #{sects.size} sect(s)"
 
   
   ## note - replace hr with blank line
   txt = sects.join( "\n\n" )


  ###
  ## remove pre comments
  txt = txt.gsub( "<!-- start pre -->\n", '' )
  txt = txt.gsub( "<!-- end pre -->\n", '' )

 
    txt = handle_about( txt )  ## e.g. about this document

    txt = handle_headings( txt )



    txt = handle_tables( txt )     ## e.g. final/halfway table (aka standings)
    txt = handle_topscorers( txt )


    txt = handle_errata_txt( txt )
 

    
  #####
   ## line-by-line processing / matching

   newtxt = String.new 
   txt.each_line do |line|  
        ## check if line incl. newline? - yes

         ## note - handle_header returns nil if no match
         ##            otherwise the reformatted (new) line !!!
         newline = handle_header( line.rstrip )
         
         newtxt <<   (newline ? newline : line)
   end
         
   txt = newtxt

  
   txt = handle_score( txt )

 

   txt = handle_goals( txt )


  ###
  ## todo
  ##   fix subs in lineup  in oost00.txt
  # Salzburg: Safar - Szewczyk (97./Lipcsei) - Winklhofer, C.Jank - Laessig,
  #        Hütter (71./Meyssen) - Nikolic, Aufhauser, Kitzbichler - Struber,
  #        Polster (56./Sabitzer)



  txt
end



