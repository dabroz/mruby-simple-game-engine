def log(*args)
  puts(*args)
end

class Numeric
  def abs
    return -self if self < 0
    self
  end
end

include Vec4::GLSL

def safely
  yield
rescue StandardError => e
  log "Error: #{e}"
  log e.backtrace.join("\n")
  $game = nil
end

def main_init
  safely do
    @background = Background.new
  end
end

def main_render
  safely do
    @background.render
    $game&.render
  end
end

def main_update(dt)
  safely do
    $game&.update(dt)
  end
end
