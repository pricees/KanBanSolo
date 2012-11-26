#!/usr/local/bin/ruby
require "curses"
require "./lib/kan_ban_solo"

# This is the driver for the program, I am just skeletoning some things out.

WIDTH   = 20
HEIGHT  = 5

def get_input(win, text_box)
  win.setpos(1,1)
  win.box("|", "-")
  win.addstr("[text]: " + text_box.text)
  win.setpos(1,9)
  win.refresh

  Curses.echo
  text_box.text = win.getstr
  Curses.noecho

  win.clear
  win.refresh
end

begin
  Curses.init_screen
  Curses.noecho

  input_window = Curses::Window.new(3, 0, Curses.lines-3, 1)

  win  = Curses::Window.new(Curses.lines-5, Curses.cols - 2, 1, 1)
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
    when 10
      get_input(input_window, board.current)
      board.redraw
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
