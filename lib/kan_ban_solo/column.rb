module KanBanSolo
  class Column
    attr_accessor :height, :width, :x, :y
    attr_accessor :parent, :subwindow, :window

    def initialize(params = {})
      if block_given?
        yield(self)
      else
        params.each { |k, v| send("#{k}=".to_sym, v) }
      end
    end

    def subwindows
      @subwindows ||= []
    end

    def window
      @window ||= begin
                    w = parent.subwin(height, width, y, x)
                    w.keypad(true)
                    w
                  end
    end

    def draw
      window.clear
      window.box(".", ".")
      subwindows.each &:draw
      window.refresh
    end

    def input_handler &block
      @input_handler = block
    end

    def handle_input
      @input_handler[self]
    end
  end
end
