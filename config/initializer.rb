require 'active_record'
require 'yaml'

$:.unshift File.join(File.expand_path(File.dirname(__FILE__)), %{ .. })

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => "db/pubmed.db")

require './lib/extractor'
require './model/journal'
require './model/article'
require './model/citation'

config_path = File.join(File.dirname(__FILE__),%w{ config.yml })
Config = YAML.load_file(config_path) if File.exists? config_path
