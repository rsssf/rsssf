

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

    txt = handle_tables( txt )     ## e.g. final/halfway table (aka standings)
    txt = handle_topscorers( txt )


 
  #####
   ## line-by-line processing / matching

   newtxt = "" 
   txt.each_line do |line|  
        ## check if line incl. newline? - yes

      newtxt <<  if m = HEADER_ROUND_RE.match(line.rstrip)
                   "▪ #{m[:round]} ▪\n" 
                 elsif m = HEADER_DATE_RE.match(line.rstrip)
                   ## e.g. [Nov 20]
                   ## e.g. [April 1]
                   "_ #{m[:date]} _\n" 
                 elsif m = HEADER_DATE_IIA_RE.match(line.rstrip)
                    ## e.g  [Aug 18, 2004]  or [Aug 18 2004]
                    ##      [Sep 4, 2004]   or [Sep 4 2004]
                   "_ #{m[:date]} _\n" 
                 elsif m = HEADER_DATE_IIB_RE.match(line.rstrip)
                    ## e.g. Nov 20 1999  or Nov 20, 1999
                    ##      Apr 1 2000   or Apr 1, 2000
                   "_ #{m[:date]} _\n" 
                 elsif m = HEADER_DATE_IIIA_RE.match(line.rstrip)
                    ## e.g. [Wed 6 Feb]
                    ##      [Sat 16 Feb]
                   "_ #{m[:date]} _\n" 
                 elsif m = HEADER_DATE_IIIB_RE.match(line.rstrip)
                    ## e.g. [Wed Feb 6]
                    ##      [Sat Feb 16]
                   "_ #{m[:date]} _\n" 
                 elsif m = HEADER_DATE_ALT_RE.match(line.rstrip)
                    ## e.g. [07-09]  
                    ##      [30-05, Thaur]
                    buf = String.new
                    buf += "_ #{m[:day]}/#{m[:month]} _"
                    buf += ", #{m[:city]}"    if m[:city]
                    buf += "\n"
                    buf
                 elsif m = HEADER_ROUND_N_DATE_RE.match(line.strip)
                   "▪ #{m[:round]} ▪  #{m[:date]}\n"                   
                 elsif m = HEADER_ROUND_N_DATE_N_CITY_RE.match(line.strip)
                   "▪ #{m[:round]} ▪  #{m[:date]}, #{m[:city]}\n"  
                 elsif m = HEADER_ROUND_N_CITY_N_DATE_RE.match(line.strip)
                    ## note - reverse (rotate) date & city
                   "▪ #{m[:round]} ▪  #{m[:date]}, #{m[:city]}\n"  
                 else
                   line 
                 end
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



