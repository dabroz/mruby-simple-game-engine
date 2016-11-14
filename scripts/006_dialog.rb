class Dialog < Component
  attr_accessor :text

  def initialize(parent, text = '')
    super(parent)
    self.text = text
  end

  def on_render
    x = parent.position.x
    y = parent.position.y
    y -= 200
    Engine.draw_sprite('data/sprite/dialog.png', x, y)
    Engine.draw_text(text, x + 150, y + 80)
  end
end
