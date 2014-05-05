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

  it "creates an POJO with a List" do
    PojoCreator.new("other_class").create_pojo('{"text" : [ { "size" : "1234", "name" : "first" } ] }').should eq(
      "public class OtherClass {"\
      "\t@JsonProperty(\"text\")"\
      "\tprivate List<Text> text;"\
    "}"\
    "public class Text {"\
    "\t@JsonProperty(\"size\")"\
    "\tprivate String size;"\
    "\t@JsonProperty(\"name\")"\
    "\tprivate String name;"\
    "}")
  end

  it "creates an POJO with a List based on the real world example with redundant names" do
    PojoCreator.new("other_class").create_pojo('{"took" : 2, "hits" : { "total" : 23, "hits" : [ { "index" : "abc", "type": "efg"}]} }').should eq(
      "public class OtherClass {"\
      "\t@JsonProperty(\"took\")"\
      "\tprivate Integer took;"\
      "\t@JsonProperty(\"hits\")"\
      "\tprivate Hits hits;"\
    "}"\
    "public class Hits {"\
    "\t@JsonProperty(\"index\")"\
    "\tprivate String index;"\
    "\t@JsonProperty(\"type\")"\
    "\tprivate String type;"\
    "}"\
    "public class Hits {"\
    "\t@JsonProperty(\"total\")"\
    "\tprivate Integer total;"\
    "\t@JsonProperty(\"hits\")"\
    "\tprivate List<Hits> hits;"\
    "}")
  end

  it "creates an POJO with a String and camel-casify the property name" do
    PojoCreator.new("ClassName").create_pojo('{"some_thing" : "something"}').should eq(
      "public class ClassName {"\
      "\t@JsonProperty(\"some_thing\")"\
      "\tprivate String someThing;"\
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

  it "creates an POJO with an Object inside with one integer field with snake_case name" do
    PojoCreator.new("ClassName").create_pojo('{"some_thing" : { "text" : "something"}}').should eq(
      "public class ClassName {"\
      "\t@JsonProperty(\"some_thing\")"\
      "\tprivate SomeThing someThing;"\
    "}"\
    "public class SomeThing {"\
    "\t@JsonProperty(\"text\")"\
    "\tprivate String text;"\
    "}")
  end



end
