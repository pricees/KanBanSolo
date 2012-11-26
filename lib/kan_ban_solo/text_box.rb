module KanBanSolo
  class TextBox

    attr_accessor :parent, :text, :height, :width ,:x, :y

    attr_reader :text_box, :window

    def initialize(params = {})
      params.each { |k, v| send("#{k}=".to_sym, v) }
    end

    def window
      @window ||= parent.subwin(height, width, y, x)
    end

    def text_box
      @text_box ||= @window.subwin(height - 2, width - 2, y + 1, x + 1)
    end


    def redraw
      draw(true)
    end

    def draw(refresh = false)
      @window = @text_box = nil if refresh

      window.clear
      window.box("|", "-")

      text_box.clear
      text_box << text || ""

      window.refresh
    end

    def input_handler &block
      @input_handler = block
    end

    def handle_input
      @input_handler[text_box]
    end
  end
end
