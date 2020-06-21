require "connect_four"

describe Board do

  describe "#drop_piece" do 
    it "adds the piece to the bottom of an empty column" do
      board = Board.new(2, 2)
      board.drop_piece(0, :red)
      expect(board.to_a).to eq([[:red, :empty], [:empty, :empty]])
    end

    it "adds the piece to the lowest empty cell in a non-empty column" do
      board = Board.new(2, 2)
      board.drop_piece(1, :red)
      board.drop_piece(1, :yellow)
      expect(board.to_a).to eq([[:empty, :empty], [:red, :yellow]])
    end

    it "throws an exception when attempting to drop in an invalid column" do
      board = Board.new(2, 2)
      expect {board.drop_piece(3, :red)}.to raise_error(Board::PieceDropError)
      expect {board.drop_piece(-1, :red)}.to raise_error(Board::PieceDropError)
    end

    it "throws an exception when attempting to drop in a full column" do
      board = Board.new(2, 2)
      board.drop_piece(1, :red)
      board.drop_piece(1, :red)
      expect {board.drop_piece(1, :red)}.to raise_error(Board::PieceDropError)
    end
  end

  describe "#game_over?" do
    it "the game is still in progress if no connect-ns have occurred" do
      board = Board.new(2, 2)
      expect(board.game_over?).to be false
    end

    it "the game ends if there is a horizontal connect-n" do
      board = Board.from_a([
        [:red, :empty, :empty, :empty],
        [:red, :empty, :empty, :empty],
        [:red, :empty, :empty, :empty],
        [:empty, :empty, :empty, :empty],
      ], 3)
      expect(board.game_over?).to be true
    end

    it "the game ends if there is a vertical connect-n" do
      board = Board.from_a([
        [:red, :empty, :empty, :empty],
        [:red, :yellow, :yellow, :yellow],
        [:empty, :empty, :empty, :empty],
        [:empty, :empty, :empty, :empty],
      ], 3)
      expect(board.game_over?).to be true
    end

    it "the game ends if there is a left-diagonal connect-n" do
      board = Board.from_a([
        [:red, :empty, :empty, :empty],
        [:red, :yellow, :red, :yellow],
        [:yellow, :red, :yellow, :empty],
        [:yellow, :yellow, :empty, :empty],
      ], 3)
      expect(board.game_over?).to be true
    end

    it "the game ends if there is a right-diagonal connect-n" do
      board = Board.from_a([
        [:red, :empty, :empty, :empty],
        [:red, :yellow, :yellow, :empty],
        [:yellow, :red, :red, :empty],
        [:yellow, :yellow, :red, :empty],
      ], 3)
      expect(board.game_over?).to be true
    end

    it "the game ends if the board is full with no connect-ns" do
      board = Board.from_a([
        [:red, :red, :yellow, :yellow],
        [:red, :yellow, :yellow, :yellow],
        [:red, :red, :red, :yellow],
        [:yellow, :yellow, :red, :red],
      ], 4)
      expect(board.game_over?).to be true
    end
  end

  describe "#winning_cells" do
    it "there are no winning cells if no connect-ns have occurred" do
      board = Board.new(2, 2)
      expect(board.winning_cells).to eq([])
    end

    it "the winning cells are recorded if there is a horizontal connect-n" do
      board = Board.from_a([
        [:red, :empty, :empty, :empty],
        [:red, :empty, :empty, :empty],
        [:red, :empty, :empty, :empty],
        [:empty, :empty, :empty, :empty],
      ], 3)
      expect(board.winning_cells).to eq([[2,0], [1,0], [0,0]])
    end

    it "the winning cells are recorded if there is a vertical connect-n" do
      board = Board.from_a([
        [:red, :empty, :empty, :empty],
        [:red, :yellow, :yellow, :yellow],
        [:empty, :empty, :empty, :empty],
        [:empty, :empty, :empty, :empty],
      ], 3)
      expect(board.winning_cells).to eq([[1,3], [1,2], [1,1]])
    end

    
    it "the winning cells are recorded if there is a left-diagonal connect-n" do
      board = Board.from_a([
        [:red, :empty, :empty, :empty],
        [:red, :yellow, :red, :yellow],
        [:yellow, :red, :yellow, :empty],
        [:yellow, :yellow, :empty, :empty],
      ], 3)
      expect(board.winning_cells).to eq([[1,3], [2,2], [3,1]])
    end

    it "the winning cells are recorded if there is a right-diagonal connect-n" do
      board = Board.from_a([
        [:red, :empty, :empty, :empty],
        [:red, :yellow, :yellow, :empty],
        [:yellow, :red, :red, :empty],
        [:yellow, :yellow, :red, :empty],
      ], 3)
      expect(board.winning_cells).to eq([[3,2], [2,1], [1,0]])
    end

    it "there are no winning cells if the board is full with no connect-ns" do
      board = Board.from_a([
        [:red, :red, :yellow, :yellow],
        [:red, :yellow, :yellow, :yellow],
        [:red, :red, :red, :yellow],
        [:yellow, :yellow, :red, :red],
      ], 4)
      expect(board.winning_cells).to eq([])
    end
  end

  describe "#winning_color" do
    it "there is no winning color if no connect-ns have occurred" do
      board = Board.new(2, 2)
      expect(board.winning_color).to be nil
    end

    it "the winning color is red if red got a connect-n" do
      board = Board.from_a([
        [:red, :empty],
        [:red, :empty],
      ], 2)
      expect(board.winning_color).to be :red
    end

    it "the winning color is yellow if yellow got a connect-n" do
      board = Board.from_a([
        [:red, :yellow],
        [:yellow, :empty],
      ], 2)
      expect(board.winning_color).to be :yellow
    end
  end

  describe "#to_a" do
    it "returns a 2D array representing the current state of the board" do
      board = Board.new(2, 2)
      expect(board.to_a).to eq([[:empty, :empty], [:empty, :empty]])
    end
  end

  describe "#from_a" do
    it "creates a board matching the state of the given 2D array" do
      original_array = [[:red, :red], [:yellow, :empty]]
      board = Board.from_a(original_array)
      expect(board.to_a).to eq(original_array)
    end
  end
end