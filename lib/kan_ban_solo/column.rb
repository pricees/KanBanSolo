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
      @window ||= parent.subwin(height, width, y, x)
    end

    def draw
      window.clear
      window.box(".", ".")
      subwindows.each &:draw
      window.refresh
    end

    def handle_input
      window.getch
    end
  end
end
