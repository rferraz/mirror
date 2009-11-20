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
    parameter_values = keywords.elements.collect(&:expressions).collect(&:build)
    [:send, variable.build, keyword_names, parameter_values]
  end
  
end