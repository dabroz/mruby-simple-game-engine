class Sprite < Component
  def initialize(parent, name, opts = {})
    super(parent)
    @name = name
    @animated = !File.exist?(path_exact)
    @offset = opts[:offset] || vec2(0, 0)
    @t = 0
  end

  def animated?
    @animated
  end

  def frame
    direction * 3 + ((@t * _speed).to_i % 3)
  end

  def path_exact
    "data/sprite/#{@name}.png"
  end

  def path_animation
    "data/sprite/#{@name}_#{frame}.png"
  end

  def path
    animated? ? path_animation : path_exact
  end

  def direction
    _move&.direction || 2
  end

  def _speed
    (_move&.speed || 0.0) / 20.0
  end

  def _move
    parent.get_component(MoveController)
  end

  def on_render
    x = parent.position.x + @offset.x
    y = parent.position.y + @offset.y
    Engine.draw_sprite(path, x, y)
  end

  def on_update(dt)
    @t += dt
  end
end
