require 'ncursesw'

class MiniGame
  def initialize
    Ncurses.initscr
    Ncurses.curs_set(0) # カーソル非表示
    Ncurses.cbreak # RAW(改行を待たない)モードにする
    Ncurses.noecho # 入力された内容をエコーしない
    Ncurses.keypad(Ncurses.stdscr, true) # KEY_* 用
    color_config

    @height, @width = Ncurses.LINES, Ncurses.COLS
    @exit = false
    @player = [@height - 1, (@width / 2) - 2]
    @bullets = Array.new(@width - 1) do
      Array.new(@height) { false }
    end
  end

  # 全てのスレッドを実行する
  def run
    threads = []
    threads << drawing_thread
    threads << input_thread
    threads << game_thread
    threads.each(&:join)
    close_scr
  rescue Interrupt
    close_scr
  end

  private

  # 色関連の設定
  def color_config
    @has_colors = Ncurses.has_colors?
    if @has_colors
      Ncurses.start_color
      if Ncurses.use_default_colors == Ncurses::OK
        Ncurses.init_pair(1, Ncurses::COLOR_CYAN, -1)
      end
    end
  end

  # 描画するスレッド
  def drawing_thread
    Thread.new do
      until @exit
        draw_player
        draw_bullets
        Ncurses.refresh
        sleep 0.01
        Ncurses.clear
      end
    end
  end

  # 入力を監視するスレッド
  def input_thread
    Thread.new do
      until @exit
        case Ncurses.getch
        when "q".ord then @exit = true
        when Ncurses::KEY_UP
          @player[0] -= 1
          @player[0] = 1 if @player[0] < 2
        when Ncurses::KEY_DOWN
          @player[0] += 1
          @player[0] = @height - 1 if @player[0] > @height - 1
        when Ncurses::KEY_RIGHT
          @player[1] += 1
          @player[1] = @width - 3 if @player[1] > @width - 3
        when Ncurses::KEY_LEFT
          @player[1] -= 1
          @player[1] = 1 if @player[1] < 1
        end
      end
    end
  end

  # 飛んでくる弾を生成したり当たり判定をしたりするスレッド
  def game_thread
    Thread.new do
      until @exit
        @bullets.map! do |row|
          row.unshift rand < 0.02
          row.pop
          row
        end
        @exit = true if gameover?
        sleep 0.1
      end
      Ncurses.move(0, 0)
      Ncurses.addstr("Game Over!\n")
      Ncurses.addstr("Please press any key...\n")
    end
  end

  # 自機を描画
  def draw_player
    Ncurses.attron(Ncurses::COLOR_PAIR(1)) if @has_colors
    Ncurses.move(*@player.zip([-1, 0]).map{ |a, b| a+b })
    Ncurses.addstr("▓")
    Ncurses.move(*@player.zip([0, -1]).map{ |a, b| a+b })
    Ncurses.addstr("▓▓▓")
    Ncurses.attroff(Ncurses::COLOR_PAIR(1)) if @has_colors
  end

  # 飛んでくる弾を描画
  def draw_bullets
    @bullets.each_with_index do |row, j|
      row.each_with_index do |bullet, i|
        if bullet
          Ncurses.move(i, j)
          Ncurses.addstr("▓")
        end
      end
    end
  end

  # 弾にあたったらゲームオーバー
  def gameover?
    @player.tap do |i, j|
      break [[i, j], [i, j-1], [i, j+1], [i-1, j]]
        .any? { |pi, pj| @bullets[pj][pi] }
    end
  end

  # 後処理
  def close_scr
    Ncurses::curs_set(1)
    Ncurses.nocbreak
    Ncurses.echo
    Ncurses.endwin
  end
end

game = MiniGame.new
game.run