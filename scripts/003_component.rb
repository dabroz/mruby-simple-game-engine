class Component
  attr_accessor :parent

  def initialize(parent)
    self.parent = parent
  end

  def on_render
  end

  def on_update(dt)
  end
end
