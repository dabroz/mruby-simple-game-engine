class Warrior < Entity
  def initialize
    super
    self.position = vec2(200, 500)
    visual_component

    ai_component do |brain|
      brain.say('I like hats')
      brain.move_to(vec2(400, 633))
      put_on_a_hat
      brain.say('Nice hat!', 2)
      loop do
        brain.move_to(vec2(400, 500))
        brain.move_to(vec2(200, 500))
      end
    end
  end

  def put_on_a_hat
    visual_component :hat, offset: vec2(14, -10)
    $game.destroy_entity(Hat)
  end
end

class Hat < Entity
  def initialize
    super
    self.position = vec2(400, 633)
    visual_component
  end
end

class Healer < Entity
  def initialize
    super
    visual_component
    self.position = vec2(600, 500)

    ai_component do |brain|
      brain.move_to(vec2(600, 300))
      brain.say('Should I go left?', 1)
      2.times do
        brain.move_to(vec2(200, 300))
        brain.move_to(vec2(400, 300))
      end
      brain.say('OK, enough.', 1)
    end
  end
end

setup_game do |game|
  game.add_entity(Warrior.new)
  game.add_entity(Hat.new)
  game.add_entity(Healer.new)
end
