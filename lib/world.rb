class World < SlotContainer

  def mirror_into(name)
    vm.universe.set_to(name, self.clone)
  end
  
end
