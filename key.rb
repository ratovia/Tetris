require 'io/console'
require 'io/console/size'

#画面を消去して、真ん中に移動しておく
print "\e[2J"

while (key = STDIN.getch) != "\C-c"
  if key == "\e" && STDIN.getch == "["
    key = STDIN.getch
  end

  # 方向を判断
  direction = case key
  when "A", "k", "w", "\u0010"; "w" #↑
  when "B", "j", "s", "\u000E"; "s" #↓
  when "C", "l", "d", "\u0006"; "d" #→
  when "D", "h", "a", "\u0002"; "a" #←
  else nil
  end

  # カーソル移動
  if key
    p key
  end
end