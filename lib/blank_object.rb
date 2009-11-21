class BlankObject
  
  instance_methods.each { |m| undef_method m unless (m =~ /^__/) || [:class, :method, :send, :is_a?].include?(m.to_sym) }
  
end
