class Proxy < BlankObject

  def initialize(vm, delegate)
    @vm = vm
    @delegate = delegate
  end
  
  def method_missing(name, *args, &block)
    if respond_to?(name)
      __send__(name, *args, &block)
    else
      @delegate.__send__(name, *args, &block)
    end
  end
  
  def method(name)
    @delegate.method(name)
  rescue
    super
  end
  
  def delegate
    @delegate
  end
  
  def vm
    @vm
  end
  
end