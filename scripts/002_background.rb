class Background
  def initialize
    noise = Perlin::Noise.new(2)

    @data = []
    @width = 40
    @height = 20
    @height.times do |y|
      row = []
      @width.times do |x|
        row << (noise[x / 10.0, y / 10.0] - 0.5) * 3
      end
      @data << row
    end
  end

  def render
    size = 64
    (@height - 1).times do |y|
      (@width - 1).times do |x|
        sprite = "data/background/#{tile_type(x, y)}.gif"
        Engine.draw_sprite(sprite, x * size, y * size)
      end
    end
  end

  private

  def [](x, y)
    # perlin noise is a floating point value, we need a threshold
    @data[y][x] > 0 ? 1 : 0
  end

  def tile_type(x, y)
    a = self[x, y]
    b = self[x + 1, y]
    c = self[x, y + 1]
    d = self[x + 1, y + 1]
    "#{a}#{b}#{c}#{d}"
  end
end
