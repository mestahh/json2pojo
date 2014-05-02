require "json"

class PojoCreator

  def initialize(class_name)
    @class_name = class_name
  end

  def create_pojo(json_string)
    json = JSON.parse(json_string)
    pojo = "public class #{@class_name} {#{get_properties(json)}\n\t\t\t}"
  end
  def get_properties(json)
  
    prop_string = ""
    json.keys.each do |property|
      prop_string += "\n\t\t\t@JsonProperty(\"#{property}\")\n\t\t\tprivate #{get_type(json[property])} #{property};"
    end
    prop_string
  end

  def get_type(value)
  	puts value.class
  	if value.class.to_s == "Fixnum"
  		return "Integer"
  	else 
  		return "String"
  	end
  end

end
