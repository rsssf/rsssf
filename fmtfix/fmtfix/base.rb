

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
                 elsif m = HEADER_DATE_III_RE.match(line.rstrip)
                    ## e.g. [Wed 6 Feb]
                    ##      [Sat 16 Feb]
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

 


   ##   [15' Barisic, 80' Gilewicz; 10' (og) Barisic]
   ##  try (simple) goal line
   ##   note keep leading spaces / indent
   txt = txt.gsub( %r{^
                     ([ ]*)
                       \[
                        ( .*? 
                           \b\d{1,3}'  ## incl. minute 
                          .*?
                        )
                      \]
                     [ ]*
                    $}ix, 
                    '\1(\2)' )

  ##  try (simple double) goal line
   ##   note keep leading spaces / indent
  ## [21' Dospel, 42' and 64' Mayrleb, 51' Datoru, 72' Sobczak; 25' and
  ## 90' B.Akwuegbu]
   txt = txt.gsub( %r{^
                     ([ ]*)
                       \[
                        ( .*? 
                           \b\d{1,3}'  ## incl. minute 
                          .*?
                          \n
                          .*?
                           \b\d{1,3}'  ## incl. minute 
                          .*?
                        )
                      \]
                     [ ]*
                    $}ix, 
                    '\1(\2)' )

###
###    [Fernando Llorente 47]
##   [Sebastián Fernández 44; Aritz Aduriz 9, Joaquín Sanchez 71, 75]
   ##  try (simple) goal line with number only!!!
   ##   note keep leading spaces / indent
   txt = txt.gsub( %r{^
                     ([ ]*)
                       \[
                        ( .*? 
                           \b\d{1,3}  ## incl. minute 
                          .*?
                        )
                      \]
                     [ ]*
                    $}ix, 
                    '\1(\2)' )


###  [Jose Manuel Jurado 12, Diego Forlán 40, 63,
##   "Simao" Pedro Fonseca 90]
##  [Rubén Suárez 10; Abdoulay Konko 12, 63, Alvaro Negredo 27,
##   "Renato" Dirnei Florencio 87]

   txt = txt.gsub( %r{^
                     ([ ]*)
                       \[
                        ( .*? 
                           \b\d{1,3}  ## incl. minute 
                          .*?
                          \n
                          .*? 
                           \b\d{1,3}  ## incl. minute 
                          .*?     
                        )
                      \]
                     [ ]*
                    $}ix, 
                    '\1(\2)' )


##  ["Edmilson" Gomes de Moraes 40, Marco Perez 68,
##   Ander Herrera 82; Fernando Fernandez 1, 27,
##   Juan Miguel Jimenez "Juanmi" 6, 28, Quincy Owusu-abeyie 35]
##  or
##  [Jose Manuel Casado 16,Emiliano Armenteros 20,
##   Jorge Andujar Moreno "Coke" 60; Jose Javier Barkero 14pen,
##   Jose Antonio Culebras 90+].
##    note - remove optional trailing dot!!
txt = txt.gsub( %r{^
                     ([ ]*)
                       \[
                        ( .*? 
                           \b\d{1,3}  ## incl. minute 
                          .*?
                          \n
                          .*? 
                           \b\d{1,3}  ## incl. minute 
                          .*?     
                          \n
                          .*? 
                           \b\d{1,3}  ## incl. minute 
                          .*?     
                        )
                      \]
                      \.?  ## optional trailing dot
                     [ ]*
                    $}ix, 
                    '\1(\2)' )




  ###
  ## todo
  ##   fix subs in lineup  in oost00.txt
  # Salzburg: Safar - Szewczyk (97./Lipcsei) - Winklhofer, C.Jank - Laessig,
  #        Hütter (71./Meyssen) - Nikolic, Aufhauser, Kitzbichler - Struber,
  #        Polster (56./Sabitzer)



  txt
end



