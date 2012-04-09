$:.unshift File.join(File.dirname(__FILE__), %w{ .. lib  })
require 'extractor'
require 'yaml'
include PubMed

describe Extractor,".new" do

  before :all do
    @filename = File.join(File.dirname(__FILE__), %w{ .. db fixtures article.nxml })
    @corrects = YAML.load_file(File.join(File.dirname(__FILE__), %w{ .. db fixtures article_corrects.yml }))
    @corrects = Hash[ @corrects.map{|k,v| [k.to_sym,v]} ]
  end

  subject { Extractor.new(File.read(@filename), :parser=>:libxml) }

  it { should be_instance_of Extractor }
  its(:journal_tag) {
    should be_instance_of String
    should == @corrects[:journal_tag]
  }

  its(:article_id)  { 
    should be_instance_of String
    should == @corrects[:article_id]
  }

  its(:references) {
    should be_instance_of Array
  }

  its(:year){
    should > 0
    should == @corrects[:year]
  }

end
