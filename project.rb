require 'gosu'

class GameWindow < Gosu::Window
  WIDTH = 800
  HEIGHT = 600

  def initialize
    super(WIDTH, HEIGHT)
    self.caption = 'Dont let Messi touch the ball!'
    @player = Messi.new(self)
    @goldenballs = Array.new()
    @score = 0
    @font = Gosu::Font.new(30)
    @background_music = Gosu::Song.new('Among Us Drip Theme Song Original.mp3')

    @background_music.play(true)
    @background_image = Gosu::Image.new('background.jpg')
    @window_shrunk = false  
    @shrink_time = random_time 
    @small_width = 400
    @small_height = 300

    @window_shrinked_time = nil
  end

  def update
    @player.move_left if Gosu.button_down?(Gosu::KbLeft)
    @player.move_right if Gosu.button_down?(Gosu::KbRight)
    @player.move_up if Gosu.button_down?(Gosu::KbUp)
    @player.move_down if Gosu.button_down?(Gosu::KbDown)
    if Gosu.milliseconds >= @shrink_time and !@window_shrunk
      shrink_window
    end
    if @window_shrunk and Gosu.milliseconds >= @window_shrinked_time + 1000
      restore_window_size
    end
    spawn_balls
    update_balls
    check_for_collisions
    @score = Gosu.milliseconds / 1000
  end

  def shrink_window
    self.width = @small_width
    self.height = @small_height
    @window_shrunk = true
    @window_shrinked_time = Gosu.milliseconds
  end

  def restore_window_size
    self.width = WIDTH
    self.height = HEIGHT
  end
  def random_time
    return Gosu.milliseconds + rand(5000..15000)
  end

  def draw
    @background_image.draw(0, 0, 0)
    @player.draw
    @goldenballs.each(&:draw)
    @font.draw_text("Score: #{@score}", 10, 10, 0)


  end
  def spawn_balls
    if rand(0..100) < 2
      @goldenballs << Goldenball.new(self)
    end
  end

  def update_balls
    @goldenballs.each(&:update)
    
  end

  def check_for_collisions
    @goldenballs.each do |goldenball|
      if collision?(goldenball, @player)
        puts "Game Over! Your score: #{@score}"

        close
      end
    end
  end

  def collision?(a, b)
    a.x < b.x + b.width and
      a.x + a.width > b.x and
      a.y < b.y + b.height and
      a.y + a.height > b.y
  end
  
end

class Goldenball
  attr_reader :x, :y, :width, :height

  def initialize(window)
    @window = window
    @width = 50
    @height = 50
    @x = rand(@window.width - @width)
    @y = -@height
    @speed = rand(1..4)
    @image = Gosu::Image.new('gb.jpg')
  end

  def update
    @y += @speed
    reset_position if @y > @window.height
  end

  def draw
    @image.draw(@x, @y, 0)
  end

  private

  def reset_position
    @x = rand(@window.width - @width)
    @y = -@height
    @speed = rand(1..5)
  end
end


class Messi
  attr_reader :x, :y, :width, :height

  def initialize(window)
    @x = window.width / 2
    @y = window.height / 2
    @width = 50
    @height = 50
    @speed = 10
    @image = Gosu::Image.new('player.jpg')
  end

  def move_left
    @x -= @speed if @x > 0
  end

  def move_right
    @x += @speed if @x < GameWindow::WIDTH - @image.width
  end

  def move_up
    @y -= @speed if @y > 0
  end

  def move_down
    @y += @speed if @y < GameWindow::HEIGHT - @image.height
  end

  def draw
    @image.draw(@x, @y, 0)
  end
end

window = GameWindow.new
window.show