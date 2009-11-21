class Proxy < BlankObject

  def initialize(delegate)
    @delegate = delegate
  end
  
  def method_missing(sym, *args, &block)
    @delegate.__send__(sym, *args, &block)
  end
  
end