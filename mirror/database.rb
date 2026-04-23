
require 'cocos'
require 'active_record'   ## todo: add sqlite3? etc.



##
# use a sqlite database for caching pages and (internal) links
##
## use via activerecord


module MirrorDb
module Model

class Page <  ActiveRecord::Base  # ApplicationRecord
   self.table_name = 'pages'
end # class Page

end   # module Model
end



module MirrorDb
class CreateDb
def up
  ActiveRecord::Schema.define do

####
# pages tables
create_table :pages do |t|
   t.string :path, null: false

   t.string :encoding
   t.string :title

   ## or use download or date or such??
   t.boolean :cached,   default: false

  # t.timestamps  ## (auto)add - why? why not?
  #  do NOT use; save space for now - auto-generated db is read-only
end
add_index :pages, :path, unique: true


## join table  - no need for own ids
create_table :links, id: false do |t|
   t.integer  :from_page_id,  null: false
   t.integer  :to_page_id,    null: false
end
add_index :pages, [:from_page_id,:to_page_id], unique: true
add_index :pages, :from_page_id
add_index :pages, :to__page_id

##
## add errors or log or such - why? why not?
##
  end  # Schema.define
end # method up
end # class CreateDb
end # module MirrorDb







module MirrorDb
    def self.open( path='./mirror.db' )

      ### reuse connect here !!!
      ###   why? why not?

      config = {
          adapter:  'sqlite3',
          database: path,
      }

      ActiveRecord::Base.establish_connection( config )
      # ActiveRecord::Base.logger = Logger.new( STDOUT )

        ## try to speed up sqlite
        ##   see http://www.sqlite.org/pragma.html
        con = ActiveRecord::Base.connection
        con.execute( 'PRAGMA synchronous=OFF;' )
        con.execute( 'PRAGMA journal_mode=OFF;' )
        con.execute( 'PRAGMA temp_store=MEMORY;' )

      ##########################
      ### auto_migrate
      unless Model::Page.table_exists?
          CreateDb.new.up
      end
    end  # method open
end






MirrorDb.open



puts "bye"


__END__

-- create_table(:pages)
   -> 0.0025s
-- add_index(:pages, :path, {:unique=>true})
   -> 0.0005s
-- create_table(:links, {:id=>false})
   -> 0.0004s
-- add_index(:pages, [:from_page_id, :to_page_id], {:unique=>true})
   -> 0.0003s
-- add_index(:pages, :from_page_id)
   -> 0.0003s
-- add_index(:pages, :to__page_id)
   -> 0.0002s