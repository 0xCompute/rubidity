
# core and stlibs
require 'ethscribe'  ## will pull-in cocos & friends
require 'calldata'


require 'logger'    # Note: use for ActiveRecord::Base.logger -- remove/replace later w/ LogUtils::Logger ???
require 'date'      ## check if date & datetime required ??


# 3rd party gems / libs
require 'props'           # see github.com/rubylibs/props
require 'logutils'        # see github.com/rubylibs/logutils


require 'active_record'   ## todo: add sqlite3? etc.

## add more activerecords addons/utils
# require 'tagutils'
require 'activerecord/utils'
require 'props/activerecord'      # includes ConfDb (ConfDb::Model::Prop, etc.)
require 'logutils/activerecord'   # includes LogDb (LogDb::Model::Log, etc.)



# our own code
require_relative 'scribelite/version'   # always goes first

require_relative 'scribelite/models/forward'

require_relative 'scribelite/models/scribe'
require_relative 'scribelite/models/tx'


require_relative 'scribelite/schema'      

# require_relative 'cache'
# require_relative 'importer'  ## note: require (soft dep) ordinals gems!!!




module ScribeDb

  def self.create
    CreateDb.new.up
    ConfDb::Model::Prop.create!( key: 'db.schema.scribe.version', 
                                 value: Scribelite::VERSION )
  end

  def self.create_all
    LogDb.create    # add logs table
    ConfDb.create   # add props table
    ScribeDb.create
  end

  def self.auto_migrate!
    ### todo/fix:
    ##    check props table and versions!!!!!

    # first time? - auto-run db migratation, that is, create db tables
    unless LogDb::Model::Log.table_exists?
      LogDb.create     # add logs table
    end

    unless ConfDb::Model::Prop.table_exists?
      ConfDb.create    # add props table
    end

    unless ScribeDb::Model::Scribe.table_exists?
      ScribeDb.create
    end
  end # method auto_migrate!


  def self.open( database='./scribe.db' )   ## convenience helper for sqlite only
      connect( adapter:  'sqlite3',
               database: database )

      ## build schema if database new/empty
      auto_migrate!
  end



  def self.connect( config={} )

    if config.empty?
      puts "ENV['DATBASE_URL'] - >#{ENV['DATABASE_URL']}<"

      ### change default to ./scribe.db ?? why? why not?
      db = URI.parse( ENV['DATABASE_URL'] || 'sqlite3:///scribe.db' )

      if db.scheme == 'postgres'
        config = {
          adapter: 'postgresql',
          host: db.host,
          port: db.port,
          username: db.user,
          password: db.password,
          database: db.path[1..-1],
          encoding: 'utf8'
        }
      else # assume sqlite3
       config = {
         adapter: db.scheme, # sqlite3
         database: db.path[1..-1] # scribe.db (NB: cut off leading /, thus 1..-1)
      }
      end
    end

    puts "Connecting to db using settings: "
    pp config
    ActiveRecord::Base.establish_connection( config )
    # ActiveRecord::Base.logger = Logger.new( STDOUT )
  end


  def self.setup_in_memory_db

    # Database Setup & Config
    ActiveRecord::Base.logger = Logger.new( STDOUT )
    ## ActiveRecord::Base.colorize_logging = false  - no longer exists - check new api/config setting?

    self.connect( adapter:  'sqlite3',
                  database: ':memory:' )

    ## build schema
    ScribeDb.create_all
  end # setup_in_memory_db (using SQLite :memory:)

end  # module ScribeDb






## add convenience helpers
Scribe    = ScribeDb::Model::Scribe
Tx        = ScribeDb::Model::Tx


# say hello
puts Scribelite.banner     ## if defined?($RUBYCOCOS_DEBUG) && $RUBCOCOS_DEBUG

