module Statements

  def build
    elements.collect { |element| Ast::Statement.new(element.statement.build) }
  end
  
end

module DecimalLiteral
  
  def build
    Ast::Literal.new(:decimal, text_value)
  end
  
end

module IntegerLiteral
  
  def build
    Ast::Literal.new(:integer, text_value)
  end
  
end

module StringLiteral
  
  def build
    Ast::Literal.new(:string, text_value[1, text_value.size - 2].gsub("\"\"", "\""))
  end
  
end

module Variable
  
  def build
    Ast::Variable.new(text_value)
  end
  
end

module Keyword
  
  def build
    identifier.text_value.to_sym
  end
  
end

module Primary
  
  def build
    message_expression.build
  end
  
end

module KeywordExpression
  
  def build
    keyword_names = keywords.elements.collect(&:keyword).collect(&:build)
    parameter_values = keywords.elements.collect(&:expression).collect(&:build)
    receiver = variable.respond_to?(:build) ? variable.build : Ast::Implicit.new
    Ast::Message.new(receiver, keyword_names, *parameter_values)
  end
  
end

module BinaryExpression
  
  def build
    Ast::Message.new(variable.build, selector.text_value.to_sym, expression.build)
  end
  
end

module UnaryExpression
  
  def build_sub_expression(variable, elements)
    element = elements.shift
    if element
      Ast::Message.new(build_sub_expression(variable, elements), element.selector.text_value.to_sym, *[])
    else
      variable.build
    end
  end
  
  def build
    build_sub_expression(variable, selectors.elements.reverse)
  end
  
end

module Block
  
  def build
    if arguments.respond_to?(:argument_list)
      argument_list = arguments.argument_list.build
    else
      argument_list = []
    end
    Ast::Block.new(argument_list, *statements.build)
  end
  
end

module Arguments
  
  def build
    [head.text_value] + tail.elements.collect(&:identifier).collect(&:text_value).flatten
  end
  
end

module Self
  
  def build
    Ast::Implicit.new
  end
  
end