class BlockContext

  attr_reader :block
  attr_reader :receiver
  attr_reader :last_ip
  
  def initialize(receiver, last_ip = 0, block = nil, arguments = [])
    @receiver = receiver
    @last_ip = last_ip
    @block = block
    @arguments = arguments
    initialize_reference_arguments
  end

  def has_local?(name)
    @reference_arguments.has_key?(name)
  end
  
  def get_local(name)
    @reference_arguments[name]
  end
  
  def set_local(name, value)
    @reference_arguments[name] = value
  end
  
  protected
  
  def initialize_reference_arguments
    @reference_arguments = {}
    unless @block.nil?
      @reference_arguments.merge!(Hash[@block.arguments.zip(@arguments)])
      @reference_arguments.merge!(Hash[@block.temporaries.zip([nil] * @block.temporaries.size)])
    end
  end
  
end