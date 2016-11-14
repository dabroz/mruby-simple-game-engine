require 'simplecov'
SimpleCov.start

require 'coveralls'
Coveralls.wear!

require 'fiber'
class Vec2
  attr_reader :x
  attr_reader :y
  def initialize(x, y)
    @x = x
    @y = y
  end

  def ==(other)
    (@x == other.x) && (@y == other.y)
  end

  def +(other)
    Vec2.new(@x + other.x, @y + other.y)
  end

  def -(other)
    Vec2.new(@x - other.x, @y - other.y)
  end

  def *(other)
    return self * vec2(other, other) if other.is_a? Numeric
    Vec2.new(@x * other.x, @y * other.y)
  end

  def abs
    Vec2.new(@x.abs, @y.abs)
  end

  def <=(other)
    return @x <= other && @y <= other if other.is_a? Numeric
    @x <= other.x && @y <= other.y
  end

  def length
    Math.sqrt(@x * @x + @y * @y)
  end

  def normalize
    self * (1.0 / length)
  end
end
class Vec4
  module GLSL
    def vec2(x, y)
      Vec2.new(x, y)
    end
  end
end
require_relative '../scripts/001_main.rb'
require_relative '../scripts/003_component.rb'
require_relative '../scripts/004_sprite.rb'
require_relative '../scripts/005_move_controller.rb'
require_relative '../scripts/006_dialog.rb'
require_relative '../scripts/007_brain.rb'
require_relative '../scripts/008_entity.rb'
require_relative '../scripts/009_game.rb'
def log(*args)
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
  config.shared_context_metadata_behavior = :apply_to_host_groups
end
