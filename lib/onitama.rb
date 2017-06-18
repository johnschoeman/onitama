require 'byebug'
# A ruby file that plays the boardgame Onitama, see README.
require 'open-uri'
require_relative 'board'
require_relative 'card'
require_relative 'piece'
require_relative 'human_player'
require_relative 'computer_player'


class Onitama

  @@help_message = "\tType 'board' or 'b' to show the board
  \tType 'cards' or 'c' to show your available cards
  \tType 'quit' or 'q' to exit
  \tType 'help' or 'h' for help
  \tType 'rules' or 'r' for rules"

  attr_reader :board, :players, :cards

  def initialize(players)
    @players = players
    @board = Board.new
    @current_player = 0
    setup_game
  end

  def setup_game
    @board.setup_pieces(@players)
    setup_cards
  end

  # Choose 5 cards at random and assign 2 to each player and 1 to the board.
  def setup_cards
    cards = Card.initial_cards
    @players[0].cards[1] = cards.shift
    @players[0].cards[2] = cards.shift
    @players[1].cards[1] = cards.shift
    @players[1].cards[2] = cards.shift
    @board.card << cards.shift
  end

  def play
    game_start
    play_turn
  end

  def game_start
    puts "--Welcome to Onitama!--"
    puts ""
    puts @@help_message
    puts ""
  end

  def play_turn
    loop do
      puts "#{@players[@current_player].name} it's your turn!"
      @board.print_board
      piece, card, to_pos = get_player_move
      next unless move_is_valid?(to_pos)
      if move_ends_game?(piece, to_pos)
        move_piece(piece, to_pos)
        declare_winner(@players[@current_player])
      end
      @board.move_piece(piece, to_pos)
      update_cards(card)
      switch_players
    end
  end

  def get_player_move
    piece_num = get_piece_selection
    piece = @players[@current_player].get_piece_by_num(piece_num.to_i)
    card_num = get_card_selection(piece)
    card = @players[@current_player].get_card_by_num(card_num.to_i)
    to_pos_num = get_move_selection(piece, card)
    to_pos = piece.available_moves_as_hash(card)[to_pos_num.to_i]

    [piece, card, to_pos]
  end

  def get_piece_selection
    get_selection("Choose piece: ", @players[@current_player].available_pieces)
  end

  def get_card_selection(piece)
    get_selection("Choose card: ", @players[@current_player].available_cards_with_moves(piece))
  end

  def get_move_selection(piece, card)
    get_selection("Choose move: ", piece.available_moves_as_hash(card))
  end

  # input must be a hash.
  def get_selection(message, options)
    loop do
      puts "#{message}#{options}"
      user_input = gets.chomp.downcase
      if options.keys.include?(user_input.to_i)
        puts "you chose #{options[user_input.to_i]}"
        return user_input
      else
        handle_non_move_choice(user_input)
      end
    end
  end

  def handle_non_move_choice(user_input)
    case user_input
    when "back", "restart", "r"
      #code to get to start of input
    when "exit", "quit", "q"
      quit_game
    when "cards", "card", "c"
      @players[@current_player].print_cards
      @board.print_card
      @players[(@current_player + 1) % 2].print_cards
    when "board", "b"
      @board.print_board
    when "help", "h"
      puts @@help_message
    when "rules", "r"
      link_to_rules
    else
      puts "#{user_input} is not a vaild input"
    end
  end

  def link_to_rules
    link = "http://www.arcanewonders.com/resources/Onitama_Rulebook.PDF"
    if RbConfig::CONFIG['host_os'] =~ /mswin|mingw|cygwin/
      system "start #{link}"
    elsif RbConfig::CONFIG['host_os'] =~ /darwin/
      system "open #{link}"
    elsif RbConfig::CONFIG['host_os'] =~ /linux|bsd/
      system "xdg-open #{link}"
    end
  end

  def move_is_valid?(to_pos)
    piece_at_pos = @board[to_pos]
    return true if piece_at_pos.nil?
    if piece_at_pos.owner == @players[@current_player]
      puts "You can't take your own piece."
      return false
    end
    true
  end

  def move_ends_game?(piece, to_pos)
    piece_at_pos = @board[to_pos]
    return false if piece_at_pos.nil?
    return true if piece_at_pos.number == 5
    if to_pos == [0, 2] && @players[@current_player].color == "black" && piece.number == 5
      return true
    elsif to_pos == [4, 5] && @players[@current_player].color == "white" && piece.number == 5
      return true
    end
    false
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
  human1 = HumanPlayer.new("Fin the Human")
  computer1 = ComputerPlayer.new("Cicel the Robot")
  game = Onitama.new([human1, computer1])
  game.play
end
