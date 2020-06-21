class Board

  def initialize(width = 7, height = 6, connect_n = 4)
    @width = width
    @height = height
    @connect_n = connect_n
    @state = GameState.new(false, [])
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
        @state = GameState.new(true, [])
      end
    end
  end

  def game_over?
    @state.game_over?
  end

  def winning_cells
    @state.winning_cells
  end

  def winning_color
    if @state.winning_cells.length > 0
      col_idx = @state.winning_cells[0][0]
      row_idx = @state.winning_cells[0][1]
      @board[col_idx][row_idx]
    else
      nil
    end
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
      @winning_cells = []
    end

    def check
      if check_horizontal || check_vertical || check_left_diag || check_right_diag
        GameState.new(true, @winning_cells)
      else
        GameState.new(false, [])
      end
    end

    def check_horizontal
      @winning_cells = []
      total_count = get_right_count + get_left_count
      total_count >= @connect_n
    end

    def check_vertical
      @winning_cells = []
      total_count = get_up_count + get_down_count
      total_count >= @connect_n
    end

    def check_left_diag
      @winning_cells = []
      total_count = get_up_left_count + get_down_left_count
      total_count >= @connect_n
    end

    def check_right_diag
      @winning_cells = []
      total_count = get_up_right_count + get_down_right_count
      total_count >= @connect_n
    end

    def get_right_count
      consecutive_count = 0
      cur_col_idx = @col_idx
      while cur_col_idx < @width && consecutive_count <= @connect_n && @board[cur_col_idx][@row_idx] == @cur_color
        @winning_cells.push([cur_col_idx, @row_idx])
        cur_col_idx += 1
        consecutive_count += 1
      end
      consecutive_count
    end

    def get_left_count
      consecutive_count = 0
      cur_col_idx = @col_idx - 1
      while cur_col_idx >= 0 && consecutive_count <= @connect_n && @board[cur_col_idx][@row_idx] == @cur_color
        @winning_cells.push([cur_col_idx, @row_idx])
        cur_col_idx -= 1
        consecutive_count += 1
      end
      consecutive_count
    end

    def get_up_count
      consecutive_count = 0
      cur_row_idx = @row_idx
      while cur_row_idx < @height && consecutive_count <= @connect_n && @board[@col_idx][cur_row_idx] == @cur_color
        @winning_cells.push([@col_idx, cur_row_idx])
        cur_row_idx += 1
        consecutive_count += 1
      end
      consecutive_count
    end

    def get_down_count
      consecutive_count = 0
      cur_row_idx = @row_idx - 1
      while cur_row_idx >= 0 && consecutive_count <= @connect_n && @board[@col_idx][cur_row_idx] == @cur_color
        @winning_cells.push([@col_idx, cur_row_idx])
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
        @winning_cells.push([cur_col_idx, cur_row_idx])
        cur_row_idx += 1
        cur_col_idx -= 1
        consecutive_count += 1
      end
      consecutive_count
    end

    def get_down_left_count
      consecutive_count = 0
      cur_row_idx = @row_idx - 1
      cur_col_idx = @col_idx + 1
      while cur_row_idx >= 0 && cur_col_idx < @width && consecutive_count <= @connect_n && @board[cur_col_idx][cur_row_idx] == @cur_color
        @winning_cells.push([cur_col_idx, cur_row_idx])
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
        @winning_cells.push([cur_col_idx, cur_row_idx])
        cur_row_idx += 1
        cur_col_idx += 1
        consecutive_count += 1
      end
      consecutive_count
    end

    def get_down_right_count
      consecutive_count = 0
      cur_row_idx = @row_idx - 1
      cur_col_idx = @col_idx - 1
      while cur_row_idx >= 0 && cur_col_idx >= 0 && consecutive_count <= @connect_n && @board[cur_col_idx][cur_row_idx] == @cur_color
        @winning_cells.push([cur_col_idx, cur_row_idx])
        cur_row_idx -= 1
        cur_col_idx -= 1
        consecutive_count += 1
      end
      consecutive_count
    end
  end

  class GameState
    attr_reader :winning_cells
    def initialize(game_is_over, winning_cells)
      @game_is_over = game_is_over
      @winning_cells = winning_cells
    end
  
    def game_over?
      @game_is_over
    end
  end

end