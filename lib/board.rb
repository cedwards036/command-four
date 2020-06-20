class Board
    def initialize(width, height)
        @width = width
        @height = height
        @board = Array.new(@width) {Array.new(@height, :empty)}
    end

    def drop_piece(column, color)
        if column < 0 || column >= @width
            raise PieceDropError.new("Invalid column index: #{column}")
        elsif full?(column)
            raise PieceDropError.new("Column #{column} is already full")
        else
            first_empty_cell_index = @board[column].index {|cell| cell == :empty}
            @board[column][first_empty_cell_index] = color
        end
    end

    def self.from_a(arr)
        board = Board.new(arr.length, arr[0].length)
        for i in 0...arr[0].length
            for j in 0...arr.length
                board.drop_piece(j, arr[j][i])
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

    def full?(column)
        @board[column][-1] != :empty
    end

end