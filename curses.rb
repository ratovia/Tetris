# encoding: utf-8
# Ruby公式のサンプル

require 'curses'

Curses.init_screen

Curses.init_screen

begin
    s = "Hello World!"
    win = Curses::Window.new(7, 40, 5, 10)
    win.box(?|,?-,?*)
    win.setpos(win.maxy / 2, win.maxx / 2 - (s.length / 2))
    win.addstr(s)
    win.refresh
    win.getch
    win.close
ensure
    Curses.close_screen
end