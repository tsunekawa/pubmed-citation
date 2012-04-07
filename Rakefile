require './config/initializer'

desc "import article metadata from xml files"
task :import do
  direxp = (ENV["filepath"] || Config["datadir"])
  raise if direxp.nil?

  limit  = (ENV["limit"] || 10)
  Dir.glob(direxp)[0..limit].each do |f|
    puts Article.import_file f
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
