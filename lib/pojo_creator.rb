require "json"

class PojoCreator

  def initialize(class_name)
    @class_name = class_name
  end

  def create_pojo(json_string)
    json = JSON.parse(json_string)
    pojo = "public class #{@class_name} {#{get_properties(json)}}" + @additional_classes
  end

  def get_properties(json)
    prop_string = ""
    @additional_classes = ""
    json.keys.each do |property|
      if (json[property].class.to_s == "Hash")
        @additional_classes += "public class #{get_class_name(property)} {" + get_properties(json[property]) + "}"
        prop_string += "\t@JsonProperty(\"#{property}\")\tprivate Text #{property};"
      else
        prop_string += "\t@JsonProperty(\"#{property}\")\tprivate #{get_type(json[property])} #{get_field_name(property)};"
      end
    end
    prop_string

  end

  def get_field_name(property)
    property.gsub(/_./, &:upcase).gsub(/_/,"")
  end

  def get_class_name(property)
    property.capitalize
  end

  def get_type(value)
    if value.class.to_s == "Fixnum"
      return "Integer"
    else
      return "String"
    end
  end

end
