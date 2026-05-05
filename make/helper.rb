
$LOAD_PATH.unshift( './rsssf/lib' )
require 'rsssf'


Webcache.root = './cache'
## Webcache.root = '/sports/cache'   ## use "global" (shared) cache


include RsssfUtils   ## e.g. archive_dir_for_season
