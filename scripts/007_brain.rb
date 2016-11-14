class Brain < Component
  attr_reader :state

  def initialize(parent, &proc)
    super(parent)
    @fiber = Fiber.new(&proc)
    @state = :waiting
  end

  def debug(text)
    log("#{parent.class}: #{text}.")
  end

  def on_update(dt)
    send("process_#{@state}", dt)
  end

  def process_finished(_dt)
  end

  def process_waiting(_dt)
    @state = @fiber.resume(self)
    return if @fiber.alive?
    debug('ended')
    @state = :finished
    @fiber = nil
  end

  def process_moving(_dt)
    move_controller = parent.get_or_create_component(MoveController)
    if (parent.position - @target).length < 1
      move_controller.dir = vec2(0, 0)
      @state = :waiting
    else
      dir = (@target - parent.position).normalize * 80
      move_controller.dir = dir
    end
  end

  def process_saying(dt)
    @time -= dt
    return unless @time < 0
    parent.remove_component(Dialog)
    @state = :waiting
  end

  def move_to(target)
    debug("move to #{target}")
    @target = target
    Fiber.yield :moving
  end

  def say(text, time = 5)
    debug("say '#{text}' for #{time} seconds")
    @time = time
    parent.get_or_create_component(Dialog).text = text
    Fiber.yield :saying
  end
end
