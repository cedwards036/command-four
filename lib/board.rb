class Board
  def initialize(width = 7, height = 6, connect_n = 4)
    @width = width
    @height = height
    @connect_n = connect_n
    @state = GameState.new(false)
    @board = Array.new(@width) {Array.new(@height, :empty)}
    @completed_moves = 0
    @max_moves = width * height
  end

  def drop_piece(column, color)
    if game_over?()
      raise PieceDropError.new("Game is already over")
    elsif invalid_index?(column)
      raise PieceDropError.new("Invalid column index: #{column}")
    elsif full?(column)
      raise PieceDropError.new("Column #{column} is already full")
    else
      first_empty_cell_index = @board[column].index {|cell| cell == :empty}
      @board[column][first_empty_cell_index] = color
      @completed_moves += 1
      @state = ConnectNChecker.new(@board, @connect_n, column, first_empty_cell_index).check
      if @completed_moves >= @max_moves && !game_over?()
        @state = GameState.new(true)
      end
    end
  end

  def game_over?
    @state.game_over?
  end

  def self.from_a(arr, connect_n = 4)
    board = Board.new(arr.length, arr[0].length, connect_n)
    for i in 0...arr[0].length
      for j in 0...arr.length
        if arr[j][i] != :empty
          board.drop_piece(j, arr[j][i])
        end
      end
    end
    board
  end

  def to_a
    @board
  end

  class PieceDropError < StandardError
  end

  private

  def invalid_index?(column)
    column < 0 || column >= @width
  end

  def full?(column)
    @board[column][-1] != :empty
  end

  class ConnectNChecker

    def initialize(board, connect_n, col_idx, row_idx)
      @col_idx = col_idx
      @row_idx = row_idx
      @cur_color = board[col_idx][row_idx]
      @width = board.length
      @height = board[0].length
      @board = board
      @connect_n = connect_n
    end

    def check
      if @cur_color != :empty
        game_is_over = [
          check_horizontal,
          check_vertical,
          check_left_diag,
          check_right_diag
        ].reduce(false) {|result, check| result || check}
        if game_is_over
          GameState.new(true)
        else
          GameState.new(false)
        end
      else 
        GameState.new(false)
      end
    end

    def check_horizontal
      total_count = get_right_count + get_left_count - 1
      total_count >= @connect_n
    end

    def check_vertical
      total_count = get_up_count + get_down_count - 1
      total_count >= @connect_n
    end

    def check_left_diag
      total_count = get_up_left_count + get_down_left_count - 1
      total_count >= @connect_n
    end

    def check_right_diag
      total_count = get_up_right_count + get_down_right_count - 1
      total_count >= @connect_n
    end

    def get_right_count
      consecutive_count = 0
      cur_col_idx = @col_idx
      while cur_col_idx < @width && consecutive_count <= @connect_n && @board[cur_col_idx][@row_idx] == @cur_color
        cur_col_idx += 1
        consecutive_count += 1
      end
      consecutive_count
    end

    def get_left_count
      consecutive_count = 0
      cur_col_idx = @col_idx
      while cur_col_idx >= 0 && consecutive_count <= @connect_n && @board[cur_col_idx][@row_idx] == @cur_color
        cur_col_idx -= 1
        consecutive_count += 1
      end
      consecutive_count
    end

    def get_up_count
      consecutive_count = 0
      cur_row_idx = @row_idx
      while cur_row_idx < @height && consecutive_count <= @connect_n && @board[@col_idx][cur_row_idx] == @cur_color
        cur_row_idx += 1
        consecutive_count += 1
      end
      consecutive_count
    end

    def get_down_count
      consecutive_count = 0
      cur_row_idx = @row_idx
      while cur_row_idx >= 0 && consecutive_count <= @connect_n && @board[@col_idx][cur_row_idx] == @cur_color
        cur_row_idx -= 1
        consecutive_count += 1
      end
      consecutive_count
    end

    def get_up_left_count
      consecutive_count = 0
      cur_row_idx = @row_idx
      cur_col_idx = @col_idx
      while cur_row_idx < @height && cur_col_idx >= 0 && consecutive_count <= @connect_n && @board[cur_col_idx][cur_row_idx] == @cur_color
        cur_row_idx += 1
        cur_col_idx -= 1
        consecutive_count += 1
      end
      consecutive_count
    end

    def get_down_left_count
      consecutive_count = 0
      cur_row_idx = @row_idx
      cur_col_idx = @col_idx
      while cur_row_idx >= 0 && cur_col_idx < @width && consecutive_count <= @connect_n && @board[cur_col_idx][cur_row_idx] == @cur_color
        cur_row_idx -= 1
        cur_col_idx += 1
        consecutive_count += 1
      end
      consecutive_count
    end

    def get_up_right_count
      consecutive_count = 0
      cur_row_idx = @row_idx
      cur_col_idx = @col_idx
      while cur_row_idx < @height && cur_col_idx < @width && consecutive_count <= @connect_n && @board[cur_col_idx][cur_row_idx] == @cur_color
        cur_row_idx += 1
        cur_col_idx += 1
        consecutive_count += 1
      end
      consecutive_count
    end

    def get_down_right_count
      consecutive_count = 0
      cur_row_idx = @row_idx
      cur_col_idx = @col_idx
      while cur_row_idx >= 0 && cur_col_idx >= 0 && consecutive_count <= @connect_n && @board[cur_col_idx][cur_row_idx] == @cur_color
        cur_row_idx -= 1
        cur_col_idx -= 1
        consecutive_count += 1
      end
      consecutive_count
    end
  end

  class GameState
    def initialize(game_is_over)
      @game_is_over = game_is_over
    end
  
    def game_over?
      @game_is_over
    end
  end

end