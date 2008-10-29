require File.dirname(__FILE__) + "/spec_helper"

describe Orange::Generator do
  before do
    @generator = Orange::Generator.new
    
    @generator.preamble
  end
  
  it "should call printf function" do
    str = @generator.new_string("")
    @generator.call("printf", str)
    @generator.finish
    
    @generator.inspect.should include("call i32 (i8*, ...)* @printf")
    @generator.run
  end
  
  it "should call define function" do
    @generator.function("test") do |g|
    end
    @generator.call("test")
    @generator.finish
    
    @generator.inspect.should include("define i32 @test()")
    @generator.run
  end

  it "should call assign string var" do
    str = @generator.new_string("")
    @generator.assign("x", str)
    @generator.call("printf", @generator.load("x"))
    @generator.finish
    
    @generator.inspect.should include("alloca",
                                      "store i8* getelementptr",
                                      "load i8**")
    @generator.run
  end

  it "should call assign numeric var" do
    num = @generator.new_number(7)
    @generator.assign("x", num)
    @generator.call("printf", @generator.new_string("%d"), @generator.load("x"))
    @generator.finish
    
    @generator.inspect.should include("alloca",
                                      "store i32 7",
                                      "load i32")
    @generator.run
  end
end