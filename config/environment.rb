require 'bundler'
require 'io/console'
require "tty-prompt"
require 'colorize'
require 'colorized_string'

Bundler.require

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')

ActiveRecord::Base.logger.level = 1

$prompt = TTY::Prompt.new

require_all 'lib'
