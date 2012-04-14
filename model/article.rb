#-*- coding:utf-8 -*-

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

    extractor = ::PubMed::Extractor.new(File.read(filename), :parser=>:libxml)
    article = Article.find_by_pmid(extractor.article_id)
    return article unless article.nil?
 
    ActiveRecord::Base::transaction do 
      journal = Journal.find_or_create_by_tag extractor.journal_tag 
      article = self.create :pmid => extractor.article_id, :journal => journal
      extractor.references.each do |ref_id|
        article.cites << Article.find_or_create_by_pmid(ref_id)
      end
      article.save
    end

    article
  end

end


