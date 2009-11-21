class BlankObject
  
  instance_methods.each { |m| undef_method m unless (m =~ /^__/) || [:respond_to?, :class, :method, :send, :is_a?].include?(m.to_sym) }
  
end
