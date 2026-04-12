
###############
## todo - fix/fix/fix/fix

=begin


(Match winners plus best 3 overall qualify for Quarterfinals)
(Os vencedores dos jogos e os outros 3 melhores passam às Quartas-de-Final)

-- rework goal line!!!!
   only if following score line  must include  4-4 or such !!!
=end


##
##  note -  exclude \n newline too!!

GOALS_ = %q{
                 [^\n\[\]]*? 
                    \b 
                    \d{1,3}  '?  ## incl. minute 
                 [^\n\[\]]*?
           }              



def handle_goals( txt )


##
##  quick fix - change [pen] to (pen) and 
##                     [og] to (og)
##   e.g. [Parkin 57 [og] - Nogan 47]
##        [McIndoe 11 [pen] Green 20, Blundell 90 - Robinson 74]


   txt = txt.gsub( '[pen]', '(pen)')
   txt = txt.gsub( '[og]', '(og)')



=begin
   ##   [15' Barisic, 80' Gilewicz; 10' (og) Barisic]
   ##  try (simple) goal line
   ##   note keep leading spaces / indent

##  note - first line must include a score!!
###      change to named captures!! - use \k<> !!!
   txt = txt.gsub( %r{^
                        (  .+?
                             \d{1,2}-\d{1,2}
                           .*?
                          \n
                         )
                     ([ ]*)
                       \[
                        ( .*? 
                           \b\d{1,3}'  ## incl. minute 
                          .*?
                        )
                      \]
                     [ ]*
                    $}ix, 
                    '\1\2(\3)' )
=end




  ##  try (simple double) goal line
   ##   note keep leading spaces / indent
  ## [21' Dospel, 42' and 64' Mayrleb, 51' Datoru, 72' Sobczak; 25' and
  ## 90' B.Akwuegbu]
  ##  -or-
  ###  [Jose Manuel Jurado 12, Diego Forlán 40, 63,
  ##   "Simao" Pedro Fonseca 90]
  ##  [Rubén Suárez 10; Abdoulay Konko 12, 63, Alvaro Negredo 27,
  ##   "Renato" Dirnei Florencio 87]

  
##  ["Edmilson" Gomes de Moraes 40, Marco Perez 68,
##   Ander Herrera 82; Fernando Fernandez 1, 27,
##   Juan Miguel Jimenez "Juanmi" 6, 28, Quincy Owusu-abeyie 35]
##  or
##  [Jose Manuel Casado 16,Emiliano Armenteros 20,
##   Jorge Andujar Moreno "Coke" 60; Jose Javier Barkero 14pen,
##   Jose Antonio Culebras 90+].
##    note - remove optional 

   txt = txt.gsub( %r{^
                     ([ ]*)
                       \[
                        (            #{GOALS_}
                              \n     #{GOALS_}
                             (?:
                                 \n  #{GOALS_}
                             )?
                        )
                      \]
                      \.?  ## optional trailing dot
                      [ ]*
                    $}ix, 
                    '\1(\2)' )


## note - match for single line goes last !!


###
###    [Fernando Llorente 47]
##   [Sebastián Fernández 44; Aritz Aduriz 9, Joaquín Sanchez 71, 75]
   ##  try (simple) goal line with number only!!!
   ##   note keep leading spaces / indent

## Fluminense     3-0   0-2  São Caetano
##    [Magno Alves 70', 88', Roni 75']
##    [Daniel 15', Magrão 46'p]

## fix/fix/fix - merge with rule above!!!
##                make minute optional!!!

   txt = txt.gsub( %r{^
                      (?<match>  .+?
                                \d{1,2}-\d{1,2}
                                .*?
                         )
                          \n 
                     (?<indent1>  [ ]*)
                       \[
                        (?<goals1> #{GOALS_})
                      \]
                     [ ]*
                (?:   ## check for second goal line following
                      ##   used in br for aggregate matches
                    \n
                    (?<indent2> [ ]*)
                       \[
                        (?<goals2> #{GOALS_})
                      \]
                     [ ]*
                )?
                    $}ix ) do |match|
                      puts "  match:"
                      puts match                    
                      m = Regexp.last_match
                      buf = String.new
                      buf += "#{m[:match]}\n"
                      buf += "#{m[:indent1]}(#{m[:goals1]})"
                      buf += "\n#{m[:indent2]}(#{m[:goals2]})"   if m[:indent2] && m[:goals2]
                      buf 
                    end 
                    
   txt 
end