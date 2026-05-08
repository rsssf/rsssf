$LOAD_PATH.unshift( './lib' )
require 'rsssf'


## Webcache.root = './cache'
Webcache.root = '/sports/cache'   ## use "global" (shared) cache


## minitest setup

require 'minitest/autorun'
