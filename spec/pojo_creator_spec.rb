require_relative '../lib/pojo_creator'

describe PojoCreator do
  it "creates an POJO with an int" do
    PojoCreator.new("ClassName").create_pojo('{"time" : 3}').should eq(
      'public class ClassName {'\
      '	@JsonProperty("time")'\
      '	private Integer time;'\
    '}')
  end

  it "creates an POJO with a String" do
    PojoCreator.new("ClassName").create_pojo('{"text" : "something"}').should eq(
      'public class ClassName {'\
      '	@JsonProperty("text")'\
      '	private String text;'\
    '}')
  end

  it "creates an POJO with an Object inside with one string field" do
    PojoCreator.new("ClassName").create_pojo('{"text" : { "text" : "something"}}').should eq(
      "public class ClassName {"\
      "\t@JsonProperty(\"text\")"\
      "\tprivate Text text;"\
    "}"\
    "public class Text {"\
    "\t@JsonProperty(\"text\")"\
    "\tprivate String text;"\
    "}")
  end



end
