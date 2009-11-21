class Proxy < BlankObject

  def initialize(vm, delegate)
    @vm = vm
    @delegate = delegate
  end
  
  def method_missing(method, *args, &block)
    if respond_to?(method)
      __send__(method, *args, &block)
    else
      @delegate.__send__(method, *args, &block)
    end
  end
  
  def delegate
    @delegate
  end
  
  def vm
    @vm
  end
  
end