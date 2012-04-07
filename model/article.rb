#-*- coding:utf-8 -*-

require 'rexml/document'

class Article < ActiveRecord::Base
  belongs_to :journal

  #引用関係
  has_many :citations, :dependent => :destroy
  has_many :cites, :through => :citations

  #被引用関係
  has_many :citedships, :class_name => "Citation", :foreign_key => :cited_id, :dependent => :destroy
  has_many :cited, :through => :citedships, :source => :article

  # XMLファイルから情報をインポート
  def self.import_file(filename)
    @source = ::REXML::Document.new(File.open(filename,"r"))

    journal_tag  = @source.elements["/article/front/journal-meta/journal-id"].text
    article_id  = @source.elements["/article/front/article-meta/article-id[@pub-id-type='pmid']"].text
    references  = @source.get_elements("/article/back/ref-list/ref//pub-id[@pub-id-type='pmid']")
 
    ActiveRecord::Base::transaction do 
      journal = Journal.find_or_create_by_tag journal_tag 
      article = self.find_or_create_by_pmid article_id

      # まだインポートされていないArticleに情報を保存する
      article.journal = journal
      references.each do |ref_id|
        article.cites << Article.find_or_create_by_pmid(ref_id.text)
      end
      article.save
    end

    article
  end

end
