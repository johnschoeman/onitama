require 'byebug'
# A ruby file that plays the boardgame Onitama, see README.
require 'open-uri'
require_relative 'board'
require_relative 'card'
require_relative 'piece'
require_relative 'human_player'
require_relative 'computer_player'


class Onitama

  attr_reader :board, :players, :cards

  def initialize(players)
    @players = players
    @board = Board.new
    @current_player = 0

  end

  def play
    setup_game
    game_start
    play_turn
  end

  def setup_game
    @board.setup_pieces(@players)
    Card.setup_cards(@players, @board)
  end

  def game_start
    puts "--Welcome to Onitama!--"
    puts ""
    puts HumanPlayer.class_variable_get(:@@help_message)
    puts ""
  end

  def play_turn
    loop do
      puts "#{@players[@current_player].name} it's your turn!"
      @board.print_board
      piece, card, to_pos = @players[@current_player].get_player_move(@board, @players[(@current_player + 1) % 2])
      next unless move_is_valid?(piece, to_pos)
      handle_move(piece, to_pos)
      update_cards(card)
      switch_players
    end
  end

  def handle_move(piece, to_pos)
    if move_ends_game?(piece, to_pos)
      @board.move_piece(piece, to_pos)
      declare_winner(@players[@current_player])
    end
    if move_takes_piece?(to_pos)
      piece_at_pos = @board[to_pos]
      @players[(@current_player + 1) % 2].remove_piece(piece_at_pos)
    end
    @board.move_piece(piece, to_pos)
  end

  def move_is_valid?(piece, to_pos)
    return false if piece.nil? || to_pos.nil?
    piece_at_pos = @board[to_pos]
    return true if piece_at_pos.nil?
    if piece_at_pos.color == piece.color
      puts "You can't take your own piece."
      return false
    end
    true
  end

  def move_ends_game?(piece, to_pos)
    piece_at_pos = @board[to_pos]
    return true if !piece_at_pos.nil? && piece_at_pos.number == 5
    if to_pos == [0, 2] && piece.color == "black" && piece.number == 5
      return true
    elsif to_pos == [4, 2] && piece.color == "white" && piece.number == 5
      return true
    end
    false
  end

  def move_takes_piece?(to_pos)
    return false if @board[to_pos].nil?
    true
  end

  def update_cards(card)
    new_card = @board.card.shift
    @board.card << card
    @players[@current_player].cards.each_key do |k|
      @players[@current_player].cards[k] = new_card if @players[@current_player].cards[k] == card
    end
  end

  def switch_players
    @current_player = (@current_player + 1) % 2
  end

  def declare_winner(player)
    puts "Game Over."
    puts "#{player.name} has Won!"
    @board.print_board
    quit_game
  end

  def quit_game
    puts "Exiting Game."
    exit
  end
end

if __FILE__ == $PROGRAM_NAME
  human1 = HumanPlayer.new("Fin the Human", "white")
  computer1 = ComputerPlayer.new("Rudi the Robot", "black")
  computer2 = ComputerPlayer.new("Margo the Martian", "white")
  game = Onitama.new([computer2, computer1])
  game.play
end
