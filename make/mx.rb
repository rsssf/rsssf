############
#  to run use:
#   $ ruby make/mx.rb


require_relative 'helper'


##
##  note - season 2020  has special page =>  mex2-2010 (not mex2010)  !!!

proj = Rsssf::Project.new( '../clubs/mexico',
                           title: 'Mexico (México)',
                           slug:  ->(season) { season == Season('2010') ? 'mex2-' : 'mex' } )


proj.make_pages_summary


puts "bye"
