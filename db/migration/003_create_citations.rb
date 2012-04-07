#-*- coding:utf-8 -*-

class CreateCitations < ActiveRecord::Migration
  def self.up
    create_table :citations do |t|
      t.integer :article_id
      t.integer :cited_id
    end
  end

  def self.down
    drop_table(:citations)
  end
end
