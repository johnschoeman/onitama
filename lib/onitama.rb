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

  def initialize(top_player, bot_player)
    @top_player = top_player
    @bot_player = bot_player
    @board = Board.new
    @current_player = top_player
    @other_player = bot_player
  end

  def play
    setup_game
    game_start
    play_turn
  end

  def setup_game
    @board.setup_pieces(@top_player, @bot_player)
    Card.setup_cards(@top_player, @bot_player, @board)
  end

  def game_start
    puts "\t--Welcome to Onitama!--\n\n"
    puts HumanPlayer.class_variable_get(:@@help_message) + "\n\n"
  end

  def play_turn
    loop do
      puts "#{@current_player.name} it's your turn!"
      @board.print_board
      piece, card, to_pos = @current_player.get_player_move(@board, @other_player)
      next unless move_is_valid?(piece, to_pos)
      handle_move(piece, to_pos)
      update_cards(card)
      switch_players
    end
  end

  def handle_move(piece, to_pos)
    if move_ends_game?(piece, to_pos)
      @board.move_piece(piece, to_pos)
      declare_winner(@current_player)
    end
    if move_takes_piece?(to_pos)
      piece_at_pos = @board[to_pos]
      @other_player.remove_piece(piece_at_pos)
    end
    @board.move_piece(piece, to_pos)
  end

  def move_is_valid?(piece, to_pos)
    return false if piece.nil? || to_pos.nil?
    piece_at_pos = @board[to_pos]
    return true if piece_at_pos.nil?
    if piece_at_pos.side == piece.side
      puts "You can't take your own piece."
      return false
    end
    true
  end

  def move_ends_game?(piece, to_pos)
    piece_at_pos = @board[to_pos]
    return true if !piece_at_pos.nil? && piece_at_pos.number == 5
    if to_pos == [0, 2] && piece.side == "bot" && piece.number == 5
      return true
    elsif to_pos == [4, 2] && piece.side == "top" && piece.number == 5
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
    @current_player.cards.each_key do |k|
      @current_player.cards[k] = new_card if @current_player.cards[k] == card
    end
  end

  def switch_players
    if @current_player == @top_player
      @current_player = @bot_player
      @other_player = @top_player
    elsif @current_player == @bot_player
      @current_player = @top_player
      @other_player = @bot_player
    end
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
  human1 = HumanPlayer.new("Fin the Human", "top")
  computer1 = ComputerPlayer.new("Rudi the Robot", "bot")
  computer2 = ComputerPlayer.new("Margo the Martian", "top")
  game = Onitama.new(human1, computer1)
  game = Onitama.new(computer2, computer1)
  game.play
end
