require 'active_record'
require 'yaml'

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => "db/pubmed.db")

require_relative '../lib/extractor'
require_relative '../model/journal'
require_relative '../model/article'
require_relative '../model/citation'

config_path = File.join(File.dirname(__FILE__),%w{ config.yml })
Config = YAML.load_file(config_path) if File.exists? config_path
