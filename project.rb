require 'gosu'

class GameWindow < Gosu::Window
  WIDTH = 800
  HEIGHT = 600

  def initialize
    super(WIDTH, HEIGHT)
    self.caption = 'Arrow Control Game'
    @player = Player.new(self)
  end

  def update
    @player.move_left if Gosu.button_down?(Gosu::KbLeft)
    @player.move_right if Gosu.button_down?(Gosu::KbRight)
    @player.move_up if Gosu.button_down?(Gosu::KbUp)
    @player.move_down if Gosu.button_down?(Gosu::KbDown)
  end

  def draw
    @player.draw
  end
end

class Player
  attr_reader :x, :y

  def initialize(window)
    @x = window.width / 2
    @y = window.height / 2
    @speed = 5
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
