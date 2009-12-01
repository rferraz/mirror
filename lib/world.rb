class World < SlotContainer

  def mirror_into(name)
    vm.universe.set_to(name, World.new(vm, name, @slots.dup))
  end

  def mirror_into_with(name, block)
    block.receiver = vm.universe.set_to(name, World.new(vm, name, @slots.dup))
    BlockActivation.new(block)
  end
  
  def offload(value)
    vm.universe.offload(value)
    value
  end
  
end
