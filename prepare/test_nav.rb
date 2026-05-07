## to run use
##   $ ruby prepare/test_nav.rb

require_relative 'prepare/convert-navlines'



txt, edits = proc_navlines_by_sections( <<TXT )

xxx

==h2


  ‹Europe, see §eur›
    ‹South America, see §sam›
    ‹Africa, see §afr›
    ‹Asia, see §asi›
    ‹North and Central America, see §nca›
    ‹Oceania, see §oce›


===h3

‹Regular Stage, see §reg› | ‹Playoff Stage, see §play›


===h3





====h4

=-=-=
===

  ===h3b===
a
b
c

‹Overview File, see page ../tablesw/worldcup›

‹2014 Final Tournament, see page 2014f›


TXT


puts
puts "====================>"
puts txt
puts
puts "edits:"
puts edits.join("\n")
puts
puts "bye"