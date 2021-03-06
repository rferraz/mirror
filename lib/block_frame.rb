class BlockFrame
  
  attr_reader :arity
  attr_reader :ip
  attr_reader :arguments
  attr_reader :temporaries
  
  attr_accessor :receiver
  attr_accessor :home_context
  
  def initialize(vm, home_context, arity, ip, arguments, temporaries)
    @vm = vm
    @home_context = home_context
    @arity = arity
    @ip = ip
    @arguments = arguments
    @temporaries = temporaries
    @receiver = nil
    @return_block = nil
    @return_stack = nil
    @return_self = false
  end
  
  def is_returnable?
    !@return_block.nil?
  end
  
  def return_self
    @return_self = true
  end
  
  def return_self?
    @return_self
  end
  
  def returnable_with(arguments = {}, &block)
    @return_stack = arguments
    @return_block = block
  end
  
  def return
    instance_eval(&@return_block)
  end
  
  def value(*arguments)
    @vm.activate_block(self, arguments)
  end

  def inspect
    "<BlockFrame: " + arity.to_s + ":" + @ip.to_s + ">"
  end
  
  protected
  
  def return_stack
    @return_stack
  end
  
end