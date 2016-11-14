require 'spec_helper'

describe Sprite do
  it 'should calculate correct angle' do
    File.stub(:exist?) do |_name|
      true
    end

    class TestEntity < Entity
      def initialize
        super
        visual_component
        move_component
      end
    end

    entity = TestEntity.new

    move_controller = entity.get_component(MoveController)

    move_controller.dir = vec2(50, 0)
    expect(entity.get_component(Sprite).frame).to eq 3
    expect(entity.get_component(Sprite).direction).to eq 1

    move_controller.dir = vec2(-50, 0)
    expect(entity.get_component(Sprite).frame).to eq 9
    expect(entity.get_component(Sprite).direction).to eq 3

    move_controller.dir = vec2(0, 50)
    expect(entity.get_component(Sprite).frame).to eq 6
    expect(entity.get_component(Sprite).direction).to eq 2

    move_controller.dir = vec2(0, -50)
    expect(entity.get_component(Sprite).frame).to eq 0
    expect(entity.get_component(Sprite).direction).to eq 0
  end
end
