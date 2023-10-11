require 'gosu'

class GameWindow < Gosu::Window
  WIDTH = 800
  HEIGHT = 600

  def initialize
    super(WIDTH, HEIGHT)
    self.caption = 'Arrow Control Game'
    @player = Messi.new(self)
    @goldenballs = []
    @score = 0
    @font = Gosu::Font.new(30)
    @background_music = Gosu::Song.new('Among Us Drip Theme Song Original.mp3')

    @background_music.play(true)
    @background_image = Gosu::Image.new('background.jpg')
   
  end

  def update
    @player.move_left if Gosu.button_down?(Gosu::KbLeft)
    @player.move_right if Gosu.button_down?(Gosu::KbRight)
    @player.move_up if Gosu.button_down?(Gosu::KbUp)
    @player.move_down if Gosu.button_down?(Gosu::KbDown)
    spawn_balls
    update_balls
    check_collisions
    @score = Gosu.milliseconds / 1000
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

  def check_collisions
    @goldenballs.each do |goldenball|
      if collision?(goldenball, @player)
        puts "Game Over! Your score: #{@score}"

        close
      end
    end
  end

  def collision?(object1, object2)
    object1.x < object2.x + object2.width &&
      object1.x + object1.width > object2.x &&
      object1.y < object2.y + object2.height &&
      object1.y + object1.height > object2.y
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
