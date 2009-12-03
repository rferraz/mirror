class Proxy < BlankObject

  attr_reader :delegate
  
  def initialize(vm, delegate)
    @vm = vm
    @delegate = delegate
  end
  
  def method_missing(name, *args, &block)
    if respond_to?(name)
      super
    else
      delegate.__send__(name, *args, &block)
    end
  end
  
  def method(name)
    delegate.method(name)
  rescue
    super
  end
  
  protected
  
  def vm
    @vm
  end
  
end