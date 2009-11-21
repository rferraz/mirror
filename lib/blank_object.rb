class BlankObject
  instance_methods.each { |m| undef_method m unless (m =~ /^__/) || [:method, :clone, :send, :is_a?, :inspect].include?(m.to_sym) }
end
