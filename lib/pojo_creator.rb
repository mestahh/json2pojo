require "json"

class PojoCreator

  VERSION = '0.3.0'

  def initialize(class_name)
    @class_name = get_class_name(class_name)
    @additional_classes = ""
  end

  def create_pojo(json_string)
    json = JSON.parse(json_string)
    pojo = "public class #{@class_name} {#{get_properties(json)}}" + @additional_classes
  end

  private

  def get_properties(json)
    prop_string = ""

    json.keys.each do |property|
      prop_prefix = "\t@JsonProperty(\"#{property}\")\tprivate "

      if (json[property].class.to_s == "Hash")
        @additional_classes << "class #{get_class_name(property)} {" + get_properties(json[property]) + "}"
      elsif(json[property].class.to_s == "Array")
        @additional_classes << "class #{get_class_name(property)} {" + get_properties(json[property][0]) + "}"
      end
      prop_string += prop_prefix + get_type(json, property) + " " +  get_field_name(property) + ";"

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

  def get_type(json, key)

    begin
      Date.parse(json[key])
      return "Date"
    rescue

    end

    if json[key].class.to_s == "Fixnum"
      return "Integer"
    elsif json[key].class.to_s == "Float"
      return "Float"
    elsif json[key].class.to_s == "FalseClass" or json[key].class.to_s == "TrueClass"
      return "Boolean"
    elsif json[key].class.to_s == "Hash"
      return get_class_name(key)
    elsif json[key].class.to_s == "Array"
      return "List<" + get_class_name(key) + ">"
    else
      return "String"
    end
  end

end
