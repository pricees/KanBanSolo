#!/usr/local/bin/ruby
require "curses"
require "./lib/kan_ban_solo"

# This is the driver for the program, I am just skeletoning some things out.

WIDTH   = 20
HEIGHT  = 5


begin
  Curses.init_screen
  Curses.noecho

  win  = Curses::Window.new(Curses.lines-2, Curses.cols - 2, 1, 1)
  win.box("|", "-")
  win.refresh
  win.keypad(true)

  board = KanBanSolo::Board.new(height: HEIGHT, width: WIDTH, parent_window: win)
  board.board = (0..rand(3)+2).map do |col|

    (0..rand(5)).map do |row|
      KanBanSolo::TextBox.new(
        height: HEIGHT,
        width:  WIDTH  - 2,
        y: 2 + (row * HEIGHT),
        x: 2 + (col * WIDTH),
        text: "[#{col}][#{row}]",
        parent: win)
    end
  end

  board.input_handler do |board|
    case (key = board.parent_window.getch)
    when Curses::Key::LEFT  then board.col -= 1
    when Curses::Key::RIGHT then board.col += 1
    when Curses::Key::UP    then board.row -= 1
    when Curses::Key::DOWN  then board.row += 1
    when "u", "d"
      m  = key.eql?("d") ? 1 : -1
      board.move_row(m)
    when "f", "b"
      m  = key.eql?("f") ? 1 : -1
      board.move_col(m)
    when "q" then break
    else
    end
  end

  board.draw
  loop do
    board.set_cursor_at_current
    board.handle_input
  end

ensure
  Curses.close_screen
end
