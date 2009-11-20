require "rubygems"
require "treetop"

require "lib/mirror"
require "lib/mirror_extensions"
require "lib/ast"

# module Mirror
#   
#   def __depth
#     @__depth ||= 0
#   end
#   
#   def __inc_depth
#     @__depth = __depth + 1
#   end
# 
#   def __dec_depth
#     @__depth = __depth - 1
#   end
#   
# end
# 
# Mirror.instance_methods.each do |method|
#   
#   next unless method =~ /^_nt_(.*)$/
#   
#   rule = $1
#   
#   Mirror.send(:alias_method, ("_old" + method).to_sym, method.to_sym)
#   
#   Mirror.send(:define_method, method.to_sym) do
#     puts (" " * __depth) + rule
#     __inc_depth
#     result = send("_old" + method)
#     __dec_depth
#     result
#   end  
#   
# end
