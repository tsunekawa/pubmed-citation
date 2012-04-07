#-*- coding:utf-8 -*-

class CreateArticles < ActiveRecord::Migration
  def self.up
    create_table :articles do |t|
      t.integer :journal_id
      t.string  :pmid, :null => false
      t.string  :title
      t.string  :doi
      t.integer :year
    end
  end

  def self.down
    drop_table :articles
  end
end
