
module Rsssf
class  Fmtfix    ## todo: find a better name e.g. Format or Fixer or ??





def autofix( txt,  round_patterns: nil,
                   tables: true,
                   topscorers: true )

 ##
 ## make sure no tabs (expand to two spaces)
  txt = txt.gsub( "\t", '  ' )
  txt = txt.gsub( "\r\n", "\n" )  ## unify newline

  ## fix unicode space !! use code point!!
  txt = txt.gsub( /[ ]/, ' ' )



    ## e.g. final/halfway table (aka standings)
    txt = handle_tables( txt )       if tables

    txt = handle_topscorers( txt )   if topscorers



    txt = handle_errata_txt( txt )



  #####
   ## line-by-line processing / matching

   newtxt = String.new
   txt.each_line do |line|
        ## check if line incl. newline? - yes

         ## note - handle_header returns nil if no match
         ##            otherwise the reformatted (new) line !!!

         newline = if round_patterns  ### any custom pattern
                     handle_header( line.rstrip,
                                      header_round_re:        round_patterns[:header_round],
                                      header_round_n_date_re: round_patterns[:header_round_n_date] )
                   else
                     handle_header( line.rstrip )
                   end

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


end    ## class Fmtfix
end    ## module Rsssf
