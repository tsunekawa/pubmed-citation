#-*- coding:utf-8 -*-

class CreateJournals < ActiveRecord::Migration
  def self.up
    create_table :journals do |t|
      t.string :title
      t.string :tag, :null=>false
    end
  end

  def self.down
    drop_table :journals
  end
end
