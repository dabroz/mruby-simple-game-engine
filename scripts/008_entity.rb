class Entity
  attr_accessor :position
  attr_accessor :components
  attr_accessor :game

  def component(*args, &block)
    cmp = args[0].new(self, *args[1..-1], &block)
    components << cmp
    cmp
  end

  def entity_name
    self.class.to_s.downcase
  end

  def visual_component(name = nil, opts = {})
    component(Sprite, name || entity_name, opts)
  end

  def move_component(dir = nil)
    component(MoveController, dir)
  end

  def dialog_component(text = nil)
    component(Dialog, text)
  end

  def ai_component(&proc)
    component(Brain, &proc)
  end

  def get_component(klass)
    components.select { |c| c.is_a? klass }.first
  end

  def get_or_create_component(klass)
    get_component(klass) || component(klass)
  end

  def remove_component(klass)
    components.reject! { |component| component.is_a? klass }
  end

  def initialize
    self.position = vec2(0, 0)
    self.components = []
  end

  def on_render
    components.each(&:on_render)
  end

  def on_update(dt)
    components.each { |component| component.on_update(dt) }
  end
end
