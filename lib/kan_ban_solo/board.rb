module KanBanSolo
  class Board


    attr_accessor :width, :height, :parent_window
    attr_writer :board, :col, :row

    def row
      @row ||= 0
    end

    def col
      @col ||= 0
    end

    def initialize(params = {})
      if block_given?
        yield(self)
      else
        params.each { |k, v| send("#{k}=".to_sym, v) }
      end
    end

    def board
      @board ||= []
    end

    def check_boundaries(val, val_max)
      val = 0 if val >= val_max
      val = val_max - 1 if val < 0
      val
    end

    def refresh
      board.each_with_index do |rows, col|
        rows.each_with_index do |window, row|
          window.y = 2 + (row * HEIGHT)
          window.x = 2 + (col * WIDTH)
        end
      end
    end

    def input_handler &block
      @input_handler = block
    end

    def handle_input
      @input_handler[self]
    end

    def current
      self.col = check_boundaries(col, board.length)
      self.row = check_boundaries(row, board[col].length)

      while board[col][row].nil?
        self.col += 1
        self.row =  0
        current
      end

      board[col][row]
    end

    def set_cursor_at_current
      parent_window.setpos(current.window.begy, current.window.begx)
    end

    def update_board
      text_box         = board[col][row]
      board[col][row]  = nil
      old_col = col

      yield

      self.col = check_boundaries(col, board.length)
      self.row = check_boundaries(row, board[col].length)

      board[old_col].compact!
      board[col].insert(row, text_box)

      redraw
    end

    def move_row(i)
      update_board { self.row += i }
    end

    def move_col(i)
      update_board { self.col += i }
    end

    def draw
      board.each do |rows|
        rows.each &:redraw
      end
    end

    def redraw
      parent_window.clear
      refresh
      draw
      parent_window.refresh
    end
  end
end
