require "pv"
require "time"
require 'io/console'
require 'io/console/size'
require 'ncursesw'
# require "timers"

# 定数
FIELD_WIDTH = 12.freeze
FIELD_HEIGHT = 22.freeze
MINO_WIDTH = 4.freeze
MINO_HEIGHT = 4.freeze

# モジュール
module Mino
  MINO_TYPE_I = 0
  MINO_TYPE_0 = 1
  MINO_TYPE_S = 2
  MINO_TYPE_J = 3
  MINO_TYPE_L = 4
  MINO_TYPE_T = 5
  MINO_TYPE_MAX = 6
end

module Angle
  MINO_ANGLE_0 = 0
  MINO_ANGLE_90 = 1
  MINO_ANGLE_180 = 2
  MINO_ANGLE_270 = 3
  MINO_ANGLE_MAX = 4
end

# 変数
@field = Array.new(FIELD_HEIGHT){Array.new(FIELD_WIDTH)}
@display_buffer = Array.new(FIELD_HEIGHT){Array.new(FIELD_WIDTH)}
@mino_shapes = Array.new(Mino::MINO_TYPE_MAX).map{Array.new(Angle::MINO_ANGLE_MAX).map{Array.new(MINO_HEIGHT).map{Array.new(MINO_WIDTH)}}}

# ミノ初期化関数
def initialize_mino
  for i in 0...Mino::MINO_TYPE_MAX
    for j in 0...Angle::MINO_ANGLE_MAX
      for n in 0...MINO_HEIGHT
        for h in 0...MINO_WIDTH
          @mino_shapes[i][j][n][h] = 0
        end
      end
    end
  end

  # MINO_TYPE_I = 0
    # MINO_ANGLE_0 = 0
      @mino_shapes[0][0] = [
        [0,1,0,0],
        [0,1,0,0],
        [0,1,0,0],
        [0,1,0,0]
      ]
    # MINO_ANGLE_90 = 0
    # MINO_ANGLE_180 = 0
    # MINO_ANGLE_270 = 0

  # MINO_TYPE_0 = 0
    # MINO_ANGLE_0 = 0
    # MINO_ANGLE_90 = 0
    # MINO_ANGLE_180 = 0
    # MINO_ANGLE_270 = 0
  # MINO_TYPE_S = 0
    # MINO_ANGLE_0 = 0
    # MINO_ANGLE_90 = 0
    # MINO_ANGLE_180 = 0
    # MINO_ANGLE_270 = 0
  # MINO_TYPE_J = 0
    # MINO_ANGLE_0 = 0
    # MINO_ANGLE_90 = 0
    # MINO_ANGLE_180 = 0
    # MINO_ANGLE_270 = 0
  # MINO_TYPE_L = 0
    # MINO_ANGLE_0 = 0
    # MINO_ANGLE_90 = 0
    # MINO_ANGLE_180 = 0
    # MINO_ANGLE_270 = 0
  # MINO_TYPE_T = 0
    # MINO_ANGLE_0 = 0
    # MINO_ANGLE_90 = 0
    # MINO_ANGLE_180 = 0
    # MINO_ANGLE_270 = 0

end

#フィールド初期化関数
def initialize_field
  #0埋め
  for i in 0...FIELD_HEIGHT
    for j in 0...FIELD_WIDTH
      @field[i][j] = 0
    end
  end
  #左右壁生成
  for i in 0..FIELD_HEIGHT
    @field[i][0] = 1
    @field[i][FIELD_WIDTH - 1] = 1
  end
  #下壁生成
  for j in 0...FIELD_WIDTH
    @field[21][j] = 1
  end
end

# 画面描画関数
def display
  # pv{:display_buffer}
  # puts "\e[H\e[2J"
  for i in 0...FIELD_HEIGHT
    # pv{:i}
    for j in 0...FIELD_WIDTH
      print @display_buffer[i][j] == 1 ? "■" : " "
      print " "
    end
    puts
  end
end

# 画面バッファ更新関数
def update_display_buffer
  @display_buffer = Marshal.load(Marshal.dump(@field))
  mino_type = Mino::MINO_TYPE_I
  mino_angle = Angle::MINO_ANGLE_0

  pv{:mino_type}
  pv{:mino_angle}

  mino_x = 5 + @count_X
  mino_y = 0 + @count_Y

  for i in 0...MINO_HEIGHT
    for j in 0...MINO_WIDTH
      @display_buffer[mino_y + i][mino_x + j] = @display_buffer[mino_y + i][mino_x + j] | @mino_shapes[mino_type][mino_angle][i][j]
    end
    puts
  end
end

# 画面バッファ初期化関数
def initialize_display_buffer
  @display_buffer = Marshal.load(Marshal.dump(@field))
end

def initialize_ncurses
  # Ncurses.initscr
  # Ncurses.curs_set(0)
  # Ncurses.cbreak
  # Ncurses.noecho
  # Ncurses.keypad(Ncurses.stdscr, true) # KEY_* 用
end

def close_scr
  Ncurses::curs_set(1)
  Ncurses.nocbreak
  Ncurses.echo
  Ncurses.endwin
end

def time_update_thread
  Thread.new do
    until @exit
      old_time = Time.now.strftime("%M:%S")
      sleep(1)
      while (Time.now.strftime("%M:%S") != old_time)
        p "Enter different time"

        @count_Y = @count_Y + 1
        update_display_buffer
        display
        old_time = Time.now.strftime("%M:%S")
        pv{:old_time}
      end
    end
  end
end

def key_update_thread
  Thread.new do
    until @exit
      # case STDIN.getch
      # when "q" then
      #   p "quit key"
      #   @exit = true
      #   break
      # when "w" then
      #   p "Enter Up Key"
      #   update_display_buffer
      #   display
      # when "s" then
      #   @count_Y = @count_Y + 1
      #   update_display_buffer
      #   display
      # when "d" then
      #   @count_X = @count_X + 1
      #   update_display_buffer
      #   display
      # when "a" then
      #   @count_X = @count_X - 1
      #   update_display_buffer
      #   display
      # end
    end
  end
end
# Main Method
if __FILE__ == $0
  # timers = Timers::Group.new
  p "INFO::initialize start"
  # initialize_ncurses
  initialize_mino
  initialize_field
  initialize_display_buffer
  @count_X = 0
  @count_Y = 0
  p "INFO::initialize end"

  update_display_buffer

  p "INFO::first display start"
  display
  p "INFO::first display end"

  p "INFO::main loop start"
  # pv{:timers}
  threads = []
  threads << time_update_thread
  threads << key_update_thread
  threads.each(&:join)

  p "INFO::main loop end"
  # close_scr
  # puts "hello"
  # gets
end
