require "colorize"
require "command_four"

describe BoardRenderer do
  describe "#render_for_printing" do 
    it "renders an empty board as a grid with no pieces" do
      renderer = BoardRenderer.new(Board.new(3,2))
      blue_divider = "|".blue
      expect(renderer.render_for_printing).to eq(
        "+----+----+----+".blue + "\n" + 
        blue_divider + "    " + blue_divider + "    " + blue_divider + "    " + blue_divider + "\n" +
        "+----+----+----+".blue + "\n" + 
        blue_divider + "    " + blue_divider + "    " + blue_divider + "    " + blue_divider + "\n" +
        "+----+----+----+".blue
      )
    end

    it "renders any pieces on the board in their correct positions" do
      board = Board.from_a([
        [:yellow, :empty],
        [:red, :yellow]
      ])
      yellow = "\u2B24".encode('utf-8').yellow
      red = "\u2B24".encode('utf-8').red
      blue_divider = "|".blue
      renderer = BoardRenderer.new(board)
      expect(renderer.render_for_printing).to eq(
        "+----+----+".blue + "\n" + 
        blue_divider + "    " + blue_divider + " #{yellow}  " + blue_divider + "\n" + 
        "+----+----+".blue + "\n" + 
        + blue_divider + " #{yellow}  " + blue_divider + " #{red}  " + blue_divider + "\n" +
        "+----+----+".blue
      )
    end

    it "highlights the winning cells once the game has been won" do
      board = Board.from_a([
        [:yellow, :red],
        [:red, :empty]
      ], 2)
      yellow = "\u2B24".encode('utf-8').yellow
      red = "\u2B24".encode('utf-8').red
      blue_divider = "|".blue
      renderer = BoardRenderer.new(board)
      expect(renderer.render_for_printing).to eq(
        "+----+----+".blue + "\n" + 
        blue_divider + "[#{red} ]" + blue_divider + "    " + blue_divider + "\n" + 
        "+----+----+".blue + "\n" + 
        + blue_divider + " #{yellow}  " + blue_divider + "[#{red} ]" + blue_divider + "\n" +
        "+----+----+".blue
      )
    end
  end
end