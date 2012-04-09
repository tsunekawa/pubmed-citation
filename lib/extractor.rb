#-*- coding:utf-8 -*-
require 'rexml/document'
require 'xml/libxml'

module PubMed
  class Extractor

    def initialize(xmlsource,opts={})
      case (opts[:parser] || :rexml)
      when :rexml
        @parser = Parser::Rexml.new
      when :libxml
        @parser = Parser::LibXML.new
      else
        raise ArgumentError, "Parser option should be :rexml or :libxml"
      end

      @parser.parse(xmlsource,opts)
    end

    private
    def method_missing(method_name, *args)
      if @parser.respond_to? method_name
        @parser.send(method_name, *args) 
      else
        raise NoMethodError
      end
    end

  end

  module Extractor::Parser
    class ExtractError < Exception; end

    class Base
      attr_accessor :source

      def initialize
        @values = Hash.new
        @source  = nil
      end

      def self.attribute(name,opts={},&block)
	name = name.to_sym

	define_method(name) do
	  return @values[name] unless @values[name].nil?

	  begin
	    @values[name]  = block.call(@source)
	  rescue => e
	    raise ::Extractor::Parser::ExtractError, "in #{nam} : #{e.to_s}"
	  end
	end
      end
    end

    class Rexml < Base
      def parse(xmlsource,opts={})
	@source = ::REXML::Document.new(xmlsource)
      end

      attribute :journal_tag do |source|
        source.elements["/article/front/journal-meta/journal-id"].text
      end

      attribute :article_id  do |source|
        source.elements["/article/front/article-meta/article-id[@pub-id-type='pmid']"].text
      end

      attribute :year do |source|
        source.elements["/article/front/article-meta/pub-date[@pub-type='collection']/year"].text.to_i
      end

      attribute :references  do |source|
	source.get_elements("/article/back/ref-list/ref//pub-id[@pub-id-type='pmid']").map{|element|
	  element.text
	}.uniq
      end
      
    end

    class LibXML < Base
      def parse(xmlsource,opts={})
	@source = ::XML::Document.string(xmlsource)
      end

      attribute :journal_tag do |source|
        source.root.find_first("/article/front/journal-meta/journal-id").content
      end

      attribute :article_id  do |source|
        source.root.find_first("/article/front/article-meta/article-id[@pub-id-type='pmid']").content
      end

      attribute :year do |source|
        source.root.find_first("/article/front/article-meta/pub-date[@pub-type='collection']/year").content.to_i
      end

      attribute :references do |source|
        source.root.find("/article/back/ref-list/ref//pub-id[@pub-id-type='pmid']").map{|element|
	  element.content
	}.uniq
      end
    end
  end
end
