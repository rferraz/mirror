class Scoping
  
  def initialize
    @scopes = [[]]
  end
  
  def enter_scope(variables)
    @scopes.unshift(variables)
  end
  
  def leave_scope
    @scopes.shift
  end
  
  def in_scope?(variable)
    @scopes.any? { |scope| scope.include?(variable) }
  end
  
end