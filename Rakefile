require './config/initializer'
require 'logger'

desc "import article metadata from xml files"
task :import do
  logger = Logger.new("./log/error.log")
  direxp = (ENV["filepath"] || Config["filepath"])
  raise if direxp.nil?

  limit  = (ENV["limit"] || -1)
  files  = Dir.glob(direxp)
  max    = files.size

  puts "#{max} files"

  files[0..limit].inject(1) do |count,f|
    current = "#{count}/#{max}"
    begin 
      article = Article.import_file f
      puts " #{current} : #{article.pmid}"
    rescue => e
      puts "#{current} : error"
      logger.error("#{current} : #{e} in #{f}")
    end

    count+1
  end
end

desc "export citation matrix as a csv file"
task :export_csv do
  Citation.export_csv("export.csv")
end

namespace :db do
  desc "database migration"
  task :migrate do
    ActiveRecord::Migrator.migrate('db/migration', ENV["VERSION"] ? ENV["VERSION"].to_i : nil)
  end
end
