require "pv"
require "time"
require 'io/console'
require 'io/console/size'
require 'ncursesw'

# 定数
FIELD_WIDTH = 12.freeze
FIELD_HEIGHT = 22.freeze
MINO_WIDTH = 4.freeze
MINO_HEIGHT = 4.freeze
MINO_START_DROP_COL = 5

# モジュール
module Mino
  MINO_TYPE_I = 0
  MINO_TYPE_O = 1
  MINO_TYPE_S = 2
  MINO_TYPE_Z = 3
  MINO_TYPE_J = 4
  MINO_TYPE_L = 5
  MINO_TYPE_T = 6
  MINO_TYPE_MAX = 7
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
@mino_type = nil
@mino_angle = nil

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
        [0,0,0,0],
        [1,1,1,1],
        [0,0,0,0],
        [0,0,0,0]
      ]
    # MINO_ANGLE_90 = 1
      @mino_shapes[0][1] = [
        [0,0,1,0],
        [0,0,1,0],
        [0,0,1,0],
        [0,0,1,0]
      ]
    # MINO_ANGLE_180 = 2
      @mino_shapes[0][2] = [
        [0,0,0,0],
        [0,0,0,0],
        [1,1,1,1],
        [0,0,0,0]
      ]
    # MINO_ANGLE_270 = 3
      @mino_shapes[0][3] = [
        [0,1,0,0],
        [0,1,0,0],
        [0,1,0,0],
        [0,1,0,0]
      ]

  # MINO_TYPE_0 = 1
    # MINO_ANGLE_0 = 0
      @mino_shapes[1][0] = [
        [0,0,0,0],
        [0,1,1,0],
        [0,1,1,0],
        [0,0,0,0]
      ]
    # MINO_ANGLE_90 = 1
      @mino_shapes[1][1] = [
        [0,0,0,0],
        [0,1,1,0],
        [0,1,1,0],
        [0,0,0,0]
      ]
    # MINO_ANGLE_180 = 2
      @mino_shapes[1][2] = [
        [0,0,0,0],
        [0,1,1,0],
        [0,1,1,0],
        [0,0,0,0]
      ]
    # MINO_ANGLE_270 = 3
      @mino_shapes[1][3] = [
        [0,0,0,0],
        [0,1,1,0],
        [0,1,1,0],
        [0,0,0,0]
      ]
  # MINO_TYPE_S = 2
    # MINO_ANGLE_0 = 0
      @mino_shapes[2][0] = [
        [0,0,0,0],
        [0,0,1,1],
        [0,1,1,0],
        [0,0,0,0]
      ]
    # MINO_ANGLE_90 = 1
      @mino_shapes[2][1] = [
        [0,0,0,0],
        [0,0,1,0],
        [0,0,1,1],
        [0,0,0,1]
      ]
    # MINO_ANGLE_180 = 2
      @mino_shapes[2][2] = [
        [0,0,0,0],
        [0,0,0,0],
        [0,0,1,1],
        [0,1,1,0]
      ]
    # MINO_ANGLE_270 = 3
      @mino_shapes[2][3] = [
        [0,0,0,0],
        [0,1,0,0],
        [0,1,1,0],
        [0,0,1,0]
      ]
  # MINO_TYPE_Z = 3
    # MINO_ANGLE_0 = 0
      @mino_shapes[3][0] = [
        [0,0,0,0],
        [0,1,1,0],
        [0,0,1,1],
        [0,0,0,0]
      ]
    # MINO_ANGLE_90 = 1
      @mino_shapes[3][1] = [
        [0,0,0,0],
        [0,0,0,1],
        [0,0,1,1],
        [0,0,1,0]
      ]
    # MINO_ANGLE_180 = 2
      @mino_shapes[3][2] = [
        [0,0,0,0],
        [0,0,0,0],
        [0,1,1,0],
        [0,0,1,1]
      ]
    # MINO_ANGLE_270 = 3
      @mino_shapes[3][3] = [
        [0,0,0,0],
        [0,0,1,0],
        [0,1,1,0],
        [0,1,0,0]
      ]
  # MINO_TYPE_J = 4
    # MINO_ANGLE_0 = 0
      @mino_shapes[4][0] = [
        [0,0,0,0],
        [0,1,0,0],
        [0,1,1,1],
        [0,0,0,0]
      ]
    # MINO_ANGLE_90 = 1
      @mino_shapes[4][1] = [
        [0,0,0,0],
        [0,0,1,1],
        [0,0,1,0],
        [0,0,1,0]
      ]
    # MINO_ANGLE_180 = 2
      @mino_shapes[4][2] = [
        [0,0,0,0],
        [0,0,0,0],
        [0,1,1,1],
        [0,0,0,1]
      ]
    # MINO_ANGLE_270 = 3
      @mino_shapes[4][3] = [
        [0,0,0,0],
        [0,0,1,0],
        [0,0,1,0],
        [0,1,1,0]
      ]
  # MINO_TYPE_L = 5
    # MINO_ANGLE_0 = 0
      @mino_shapes[5][0] = [
        [0,0,0,0],
        [0,0,0,1],
        [0,1,1,1],
        [0,0,0,0]
      ]
    # MINO_ANGLE_90 = 1
      @mino_shapes[5][1] = [
        [0,0,0,0],
        [0,0,1,0],
        [0,0,1,0],
        [0,0,1,1]
      ]
    # MINO_ANGLE_180 = 2
      @mino_shapes[5][2] = [
        [0,0,0,0],
        [0,0,0,0],
        [0,1,1,1],
        [0,1,0,0]
      ]
    # MINO_ANGLE_270 = 3
      @mino_shapes[5][3] = [
        [0,0,0,0],
        [0,1,1,0],
        [0,0,1,0],
        [0,0,1,0]
      ]
  # MINO_TYPE_T = 6
    # MINO_ANGLE_0 = 0
    @mino_shapes[6][0] = [
      [0,0,1,0],
      [0,1,1,1],
      [0,0,0,0],
      [0,0,0,0]
    ]
    # MINO_ANGLE_90= 1
      @mino_shapes[6][1] = [
        [0,0,1,0],
        [0,0,1,1],
        [0,0,1,0],
        [0,0,0,0]
      ]
    # MINO_ANGLE_180 = 2
      @mino_shapes[6][2] = [
        [0,0,0,0],
        [0,1,1,1],
        [0,0,1,0],
        [0,0,0,0]
      ]
    # MINO_ANGLE_270 = 3
      @mino_shapes[6][3] = [
        [0,0,1,0],
        [0,1,1,0],
        [0,0,1,0],
        [0,0,0,0]
      ]

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
  for i in 0...FIELD_HEIGHT
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
  Ncurses.clear
  Ncurses.addstr(@display_buffer)
  Ncurses.refresh
end

# ランダムミノ
def random_pick_mino
  # TODO ランダム可
  @mino_type = Mino::MINO_TYPE_J
  @mino_angle = Angle::MINO_ANGLE_0
end

# 画面バッファ更新関数
def update_display_buffer
  @field_buffer = Marshal.load(Marshal.dump(@field))
  
  mino_x = MINO_START_DROP_COL + @count_X
  mino_y = 0 + @count_Y

  for i in 0...MINO_HEIGHT
    for j in 0...MINO_WIDTH
      @field_buffer[mino_y + i][mino_x + j] = @field_buffer[mino_y + i][mino_x + j] | @mino_shapes[@mino_type][@mino_angle][i][j]
    end
    puts
  end
  
  @display_buffer = ""
  for i in 0...FIELD_HEIGHT
    for j in 0...FIELD_WIDTH
      @display_buffer += @field_buffer[i][j] == 1 ? "■" : " "
      @display_buffer += " "
    end
    @display_buffer += "\n"
  end
end

# 画面バッファ初期化関数
def initialize_display_buffer
  @display_buffer = Marshal.load(Marshal.dump(@field))
end

# ncurses初期化関数
def initialize_ncurses
  Ncurses.initscr
  Ncurses.curs_set(0)
  Ncurses.cbreak
  Ncurses.keypad(Ncurses.stdscr, true) # KEY_* 用
  Ncurses.noecho
end

# ncurses終了関数
def close_scr
  Ncurses::curs_set(1)
  Ncurses.nocbreak
  Ncurses.echo
  Ncurses.endwin
end

# 一秒計算関数
def time_update_thread
  Thread.new do
    until @exit
      old_time = Time.now.strftime("%M:%S")
      sleep(1)
      while (Time.now.strftime("%M:%S") != old_time)
        @count_Y = @count_Y + 1
        update_display_buffer
        display
        old_time = Time.now.strftime("%M:%S")
      end
    end
  end
end

# キー入力関数
def key_update_thread
  Thread.new do
    until @exit
      case STDIN.getch
      when "q" then
        @exit = true
        close_scr
        break
      when "w" then
        update_display_buffer
        display
      when "s" then
        @count_Y = @count_Y + 1
        update_display_buffer
        display
      when "d" then
        @count_X = @count_X + 1
        update_display_buffer
        display
      when "a" then
        @count_X = @count_X - 1
        update_display_buffer
        display
      when "j" then
        @mino_angle = @mino_angle == Angle::MINO_ANGLE_MAX - 1 ? 0 : @mino_angle += 1
        update_display_buffer
        display
      when "l" then
        @mino_angle = @mino_angle == 0 ? Angle::MINO_ANGLE_MAX - 1 : @mino_angle -= 1
        update_display_buffer
        display
      end
    end
  end
end

# Main Method
if __FILE__ == $0
  # p "INFO::initialize start"
  initialize_ncurses
  initialize_mino
  initialize_field
  initialize_display_buffer
  @count_X = 0
  @count_Y = 0
  # p "INFO::initialize end"
  random_pick_mino
  update_display_buffer
  # p "INFO::first display start"
  display
  # p "INFO::first display end"
  # p "INFO::main loop start"
  threads = []
  threads << time_update_thread
  threads << key_update_thread
  threads.each(&:join)

end
