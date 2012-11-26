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

      col.input_handler do |col|
        @tab ||= 0

        case (x = col.window.getch)
        when Curses::Key::UP then @tab -= 1
        when Curses::Key::DOWN then @tab += 1
        else
        end

        @tab = 0 if @tab >= col.subwindows.length

        @tab = col.subwindows.length - 1 if @tab < 0

        s = col.subwindows[@tab]
        col.window.setpos(s.window.begy, s.window.begx)
      end

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

  @idx = 0
  c = 0

  loop do

    case win.getch
    when Curses::Key::LEFT then @idx -= 1
    when Curses::Key::RIGHT then @idx += 1
    when "q" then break
    else
      handle_input = true
    end

    @idx = 0 if @idx >= @columns.length
    @idx = @columns.length - 1 if @idx < 0

    c = @columns[@idx]
    win.setpos(c.window.begy, c.window.begx)

    if handle_input
      handle_input = false
      c.handle_input
    end
    $col_idx = @idx

  end
ensure
puts "col_idx = #$col_idx"
  Curses.close_screen
end
