require "./lib/board"

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