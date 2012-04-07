#-*- coding:utf-8 -*-

class Journal < ActiveRecord::Base
  has_many :articles
end
