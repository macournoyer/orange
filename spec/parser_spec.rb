require File.dirname(__FILE__) + "/spec_helper"

describe OrangeParser do
  before do
    @parser = OrangeParser.new
  end
  
  it "should parse comment" do
    @parser.parse("# ohaie").should_not be_nil
  end

  it "should parse assign" do
    @parser.parse("x = 2 + 1").should_not be_nil
  end

  it "should parse == operator" do
    @parser.parse("x == 2").should_not be_nil
  end

  it "should parse operator with expressions" do
    @parser.parse("x == 2 && a == 1").should_not be_nil
  end

  it "should parse method call" do
    @parser.parse("puts").should_not be_nil
  end
  
  it "should parse method call with arg" do
    @parser.parse(%Q{puts "hi"}).should_not be_nil
  end

  it "should parse method call with arg and parent" do
    @parser.parse(%Q{puts("hi")}).should_not be_nil
  end
  
  it "should parse method call with expression as args" do
    @parser.parse("if(x > 1 && x < 4)").should_not be_nil
  end
  
end