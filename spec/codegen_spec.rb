require File.dirname(__FILE__) + "/spec_helper"

describe "Codegen" do
  before do
    @parser = OrangeParser.new
    @generator = mock("generator")
    
    @generator.should_receive(:preamble).once
    @generator.should_receive(:finish).once
  end
  
  def compile(code)
    @parser.parse(code).compile(@generator)
  end
  
  it "should generate string" do
    @generator.should_receive(:new_string).with("cheezburger")
    compile(%Q{"cheezburger"})
  end
  
  it "should generate number" do
    @generator.should_receive(:new_number).with(7)
    compile(%Q{7})
  end
  
  it "should generate call" do
    @generator.should_receive(:call).with("test")
    compile("test()")
  end
  
  it "should generate call with args" do
    @generator.should_receive(:new_number).with(anything).twice
    @generator.should_receive(:call).with("test", anything, anything)
    compile("test(1, 2)")
  end
  
  it "should generate assign" do
    @generator.should_receive(:new_number).with(anything).once
    @generator.should_receive(:assign).with("x", anything)
    compile("x = 1")
  end
  
  it "should generate method definition" do
    @generator.should_receive(:function).with("test")
    compile(<<-EOS)
      def test()
      end
    EOS
  end
  
  it "should generate method definition with args"
end