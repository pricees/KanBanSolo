#!/usr/local/bin/ruby
require "curses"
require "./lib/kan_ban_solo"

#  This is the driver for the program, I am just skeletoning some things out.
#
begin
  Curses.init_screen
  Curses.noecho

  win  = Curses::Window.new(Curses.lines-2, Curses.cols - 2, 1, 1)
  win.box("|", "-")
  win.refresh
  win.keypad(true)


  @columns = (0..5).map do |num|

    column = KanBanSolo::Column.new do |col|
      col.height = win.maxy - 2
      col.width  = 20
      col.x      = win.begx + 1 + ((col.width + 4) * num)
      col.y      = win.begy + 1
      col.parent = win

      6.times do |i|
        col.subwindows << KanBanSolo::TextBox.new(height: 5,
                                                  width: col.width - 2,
                                                  y: col.y + 1 + (i * 6),
                                                  x: col.x + 1,
                                                  parent: col.window)
      end
    end
  end
  @columns.each &:draw
  @columns.first.handle_input

ensure
  Curses.close_screen
end
