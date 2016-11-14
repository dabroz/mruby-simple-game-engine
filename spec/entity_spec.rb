require 'spec_helper'

describe Entity do
  it 'should move entities' do
    class TestEntity < Entity
      def initialize
        super
        self.position = vec2(100, 100)
        move_component vec2(50, 0)
      end
    end

    entity = TestEntity.new
    game = Game.new
    game.add_entity(entity)

    expect(entity.position).to eq vec2(100, 100)

    game.simulate(1)

    expect(entity.position).to be_within(0.1).of(vec2(150, 100))

    game.simulate(1)

    expect(entity.position).to be_within(0.1).of(vec2(200, 100))
  end

  it 'should move entities' do
    class TestEntity < Entity
      def initialize
        super
        self.position = vec2(100, 100)
        ai_component do |brain|
          brain.move_to(vec2(200, 100))
        end
      end
    end

    entity = TestEntity.new
    game = Game.new
    game.add_entity(entity)

    expect(entity.position).to eq vec2(100, 100)

    game.simulate(1)

    expect(entity.position).to be_within(5).of(vec2(180, 100))

    game.simulate(1)

    expect(entity.position).to be_within(5).of(vec2(200, 100))
  end

  it 'should destroy entities' do
    class TestEntity < Entity
      def initialize
        super
        self.position = vec2(100, 100)
        ai_component do |_brain|
          game.destroy_entity(AnotherEntity)
        end
      end
    end
    class AnotherEntity < Entity
    end

    entity = TestEntity.new
    another_entity = AnotherEntity.new
    game = Game.new
    game.add_entity(entity)
    game.add_entity(another_entity)
    expect(game.entities.count).to eq 2

    game.simulate(1)

    expect(game.entities.count).to eq 1
  end

  it 'should allow brain to say things' do
    class TestEntity < Entity
      def initialize
        super
        self.position = vec2(100, 100)
        ai_component do |brain|
          brain.say('Hello!', 5)
        end
      end
    end

    entity = TestEntity.new
    game = Game.new
    game.add_entity(entity)

    expect(entity.get_component(Brain).state).to eq :waiting

    game.simulate(1)

    expect(entity.get_component(Brain).state).to eq :saying

    game.simulate(10)

    expect(entity.get_component(Brain).state).to eq :finished
  end
end
