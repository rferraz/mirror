class World < SlotContainer

  def mirror_into(name)
    vm.universe.set_to(name, World.new(vm, name, @slots.dup))
  end

  def mirror_into_with(name, block)
    object = vm.universe.set_to(name, World.new(vm, name, @slots.dup))
    vm.enter_context(object)
    begin
      block.value
    ensure
      vm.leave_context
    end
    object
  end
  
  def offload(value)
    vm.universe.offload(value)
    value
  end
  
end
