class Game
  attr_accessor :entities
  def initialize
    self.entities = []
  end

  def add_entity(entity)
    entity.game = self
    entities << entity
  end

  def render
    entities.each(&:on_render)
  end

  def update(dt)
    entities.each { |entity| entity.on_update(dt) }
  end

  def destroy_entity(klass)
    entities.reject! { |e| e.is_a? klass }
  end

  def simulate(time)
    step = 1.0 / 60.0
    while time > 0
      update(step)
      time -= step
    end
  end
end

def setup_game
  safely do
    $game = Game.new
    yield($game)
  end
end
