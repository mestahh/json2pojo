require_relative '../lib/pojo_creator'

describe PojoCreator do
	it "creates an POJO with an int" do
		PojoCreator.new("ClassName").create_pojo('{"time" : 3}').should eq('public class ClassName {
			@JsonProperty("time")
			private Integer time;
			}')
	end

	it "creates an POJO with a String" do
		PojoCreator.new("OtherClass").create_pojo('{"value" : "something"}').should eq('public class OtherClass {
			@JsonProperty("value")
			private String value;
			}')
	end

end