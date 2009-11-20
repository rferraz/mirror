module Statements

  def build
    elements.collect { |element| element.statement.build }
  end
  
end

module DecimalLiteral
  
  def build
    [:literal, :decimal, text_value]
  end
  
end

module IntegerLiteral
  
  def build
    [:literal, :integer, text_value]
  end
  
end

module StringLiteral
  
  def build
    [:literal, :string, text_value[1, text_value.size - 2].gsub("\"\"", "\"")]
  end
  
end

module Variable
  
  def build
    [:variable, text_value]
  end
  
end

module Keyword
  
  def build
    identifier.text_value.to_sym
  end
  
end

module KeywordExpression
  
  def build
    keyword_names = keywords.elements.collect(&:keyword).collect(&:build)
    parameter_values = keywords.elements.collect(&:expression).collect(&:build)
    [:send, variable.build, keyword_names, parameter_values]
  end
  
end

module BinaryExpression
  
  def build_sub_expression(variable, elements)
    element = elements.shift
    if element
      [:send, variable.build, element.selector.text_value.to_sym, build_sub_expression(element.expression, elements)]
    else
      variable.build
    end
  end
  
  def build
    build_sub_expression(variable, expressions.elements)
  end
  
end

module UnaryExpression
  
  def build_sub_expression(variable, elements)
    element = elements.shift
    if element
      [:send, build_sub_expression(variable, elements), element.selector.text_value.to_sym]
    else
      variable.build
    end
  end
  
  def build
    build_sub_expression(variable, selectors.elements)
  end
  
end