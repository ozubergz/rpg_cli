require 'bundler'
require 'io/console'



Bundler.require

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')

# ActiveRecord::Base.logger = Rails.logger.clone
# ActiveRecord::Base.logger.level = Logger::INFO


require_all 'lib'
