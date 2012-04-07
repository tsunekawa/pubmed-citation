require 'matrix'
require 'csv'

class Matrix
  def []=(i,j,x)
    @rows[i][j]=x
  end
end

class Citation < ActiveRecord::Base
  belongs_to :article
  belongs_to :cite, :foreign_key => :cited_id, :class_name => "Article"

  def self.to_matrix
    article_list = Article.select(:pmid).all.map(&:pmid)
    matrix = Matrix.zero(article_list.size)
 
    self.all.each do |cit|
      next if cit.article.nil? or cit.cite.nil?

      i = article_list.index(cit.article.pmid)
      j = article_list.index(cit.cite.pmid)
      matrix[i,j] = 1
    end
    matrix
  end

  def self.export_csv(filename="citation.csv")
    article_list = Article.select(:pmid).all.map(&:pmid)
    matrix = self.to_matrix
    filename = (filename || "citation.csv")
    CSV.open(filename, "w") do |writer|
      writer << [""]+ article_list
      (0..(article_list.size-1)).each do |i|
        writer << [article_list[i]]+matrix.row(i).to_a
      end
    end
  end
end
