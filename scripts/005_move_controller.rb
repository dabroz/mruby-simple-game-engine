class MoveController < Component
  attr_accessor :dir

  def initialize(parent, dir = nil)
    super(parent)
    self.dir = dir
  end

  def speed
    dir.length
  end

  def direction
    return 2 if dir.length == 0
    dd = dir.normalize
    if dd.x.abs > dd.y.abs
      dd.x > 0 ? 1 : 3
    else
      dd.y > 0 ? 2 : 0
    end
  end

  def on_update(dt)
    parent.position += dir * dt
  end
end
