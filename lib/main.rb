require 'colorize'

require './lib/board'
require './lib/board_renderer'

def main
  game_is_in_session = true
  colors = Colors.new
  print_welcome_banner
  while game_is_in_session
    play_round(colors)
    game_is_in_session = check_if_game_should_continue
  end
  puts "Thank you for playing!"
end

def print_welcome_banner
  puts "========================="
  puts " Welcome to Connect Four"
  puts "========================="
end

def play_round(colors)
  board = Board.new
  renderer = BoardRenderer.new(board)
  until board.game_over?
    puts renderer.render_for_printing
    puts "#{color_to_s(colors.current_color)}'s turn"
    play_turn(board, colors.current_color)
    colors.switch_color
  end
  print_end_of_game_summary(board, renderer)
end

def play_turn(board, color)
  turn_was_successful = false
  until turn_was_successful  
    print "Please enter a column number between 1 (far-left) and #{board.width} (far-right): " 
    response = gets.chomp
    if column_response_is_valid(response, board)
      column = response.to_i - 1
      begin
        board.drop_piece(column, color)
        turn_was_successful = true
      rescue Board::PieceDropError
        puts "Column #{response} is already full"
      end
    end
  end
end

def column_response_is_valid(response, board)
  /^[0-9]+$/ =~ response && response.to_i > 0 && response.to_i <= board.width
end

def check_if_game_should_continue
  response = ""
  until ["y", "n"].include? response
      print "Would you like to play again (y / n)? "
      response = gets.chomp.downcase
  end
  response == 'y'
end

def print_end_of_game_summary(board, renderer)
  puts renderer.render_for_printing
  if board.winning_color
    puts "#{color_to_s(board.winning_color)} wins!"
  else
    puts "It's a draw!"
  end
end

class Colors
  def initialize
    @colors = [:red, :yellow]
    @cur_colors_index = 0
  end

  def current_color
    @colors[@cur_colors_index]
  end

  def switch_color
    @cur_colors_index = (@cur_colors_index + 1) % 2
  end
end

def color_to_s(color)
  case color
  when :red
    color.to_s.capitalize.red
  when :yellow
    color.to_s.capitalize.yellow
  else
    raise "Invalid color #{color}"
  end
end

main