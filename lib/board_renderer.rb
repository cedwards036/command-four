require 'colorize'

class BoardRenderer
  def initialize(board)
    @board = board
  end

  def render_for_printing
    row_divider = ("+" + ("---+" * @board.width)).blue 
    col_divider = "|".blue
    result = "" << (row_divider + "\n")
    string_symbol_board = @board.to_a.map do |row|
      row.map {|cell_color| TextCell.new(" ", "#{color_to_s(cell_color)}", " ")}
    end
    if @board.game_over?
      add_winning_cell_highlights(string_symbol_board)
    end
    string_board = string_symbol_board.transpose.reverse.map do |row|
      col_divider + row.map(&:to_s).join(col_divider) + col_divider
    end
    result << string_board.join(+ "\n" + row_divider + "\n") << "\n" <<row_divider
  end

  private

  def color_to_s(color)
    large_filled_circle = "\u2B24".encode('utf-8')
    case color
    when :red
      large_filled_circle.red
    when :yellow
      large_filled_circle.yellow
    when :empty
      " "
    else
      raise "Invalid color #{color}"
    end
  end

  def add_winning_cell_highlights(string_symbol_board)
    @board.winning_cells.each do |coord|
      text_cell = string_symbol_board[coord[0]][coord[1]]
      text_cell.left_bookmark = "["
      text_cell.right_bookmark = "]"
    end
  end

  TextCell = Struct.new(:left_bookmark, :text, :right_bookmark) do
    def to_s
      "#{left_bookmark}#{text}#{right_bookmark}"
    end
  end
end