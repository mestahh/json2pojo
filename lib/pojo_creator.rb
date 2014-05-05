require "json"

class PojoCreator

  def initialize(class_name)
    @class_name = get_class_name(class_name)
    @additional_classes = ""
  end

  def create_pojo(json_string)
    json = JSON.parse(json_string)
    pojo = "public class #{@class_name} {#{get_properties(json)}}" + @additional_classes
  end

  def get_properties(json)
    prop_string = ""
    
    json.keys.each do |property|
      if (json[property].class.to_s == "Hash")
        @additional_classes << "public class #{get_class_name(property)} {" + get_properties(json[property]) + "}"
        prop_string += "\t@JsonProperty(\"#{property}\")\tprivate #{get_class_name(property)} #{get_field_name(property)};"
      elsif(json[property].class.to_s == "Array")
        @additional_classes << "public class #{get_class_name(property)} {" + get_properties(json[property][0]) + "}"
        prop_string += "\t@JsonProperty(\"#{property}\")\tprivate List<#{get_class_name(property)}> #{get_field_name(property)};"
      else
        prop_string += "\t@JsonProperty(\"#{property}\")\tprivate #{get_type(json[property])} #{get_field_name(property)};"
      end
    end
    prop_string

  end

  def get_field_name(property)
    snake_case_to_field_name(property)
  end

  def snake_case_to_class_name(string)
    snake_case_to_field_name(string).gsub(/(^.)/, &:upcase)
  end

  def snake_case_to_field_name(string)
    string.gsub(/(_.)/, &:upcase).gsub("_", "")
  end

  def get_class_name(property)
    snake_case_to_class_name(property)
  end

  def get_type(value)
    if value.class.to_s == "Fixnum"
      return "Integer"
    else
      return "String"
    end
  end

end

# json_file = File.open(ARGV[0])
# json = ""
# while (line = json_file.gets)
#   json += line + "\n"
# end
# puts PojoCreator.new("TestClass").create_pojo(json)