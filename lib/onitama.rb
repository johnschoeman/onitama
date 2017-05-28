# A ruby file that plays the boardgame Onitama, see README.
require 'open-uri'
require_relative 'board'
require_relative 'card'
require_relative 'piece'
require_relative 'player'


class Onitama

  @@card_list = [ :tiger, :dragon, :crab, :elephant, :monkey,
                  :mantis, :crane, :boar, :frog, :rabbit,
                  :goose, :rooster, :horse, :ox, :eel, :cobra]

  @@help_message = "\tType 'board' or 'b' to show the board
  \tType 'cards' or 'c' to show your available cards
  \tType 'quit' or 'q' to exit
  \tType 'help' or 'h' for help
  \tType 'rules' or 'r' for rules"

  attr_reader :board, :players, :cards

  def initialize
    @players = []
    @board = Board.new
    @cards = []
    @current_player = 0
    setup_game
  end

  def setup_game
    setup_players
    setup_pieces
    setup_cards
  end

  def setup_players
    @players = [Player.new("player1","white"), Player.new("player2","black")]
  end

  # Get pieces from players and place on board
  def setup_pieces
    @board.place_piece(@players[0].get_piece_by_num(5),[0,2])
    @board.place_piece(@players[1].get_piece_by_num(5),[4,2])
    (1..4).each do |n|
      if n==1||n==2
        @board.place_piece(@players[0].get_piece_by_num(n),[0,n-1])
        @board.place_piece(@players[1].get_piece_by_num(n),[4,n-1])
      else
        @board.place_piece(@players[0].get_piece_by_num(n),[0,n])
        @board.place_piece(@players[1].get_piece_by_num(n),[4,n])
      end
    end
  end

  # Choose 5 cards at random and assign 2 to each player and 1 to the board.
  def setup_cards
    while @cards.length < 5
      card = random_card
      @cards << card if !@cards.any? {|c| c.card_name == card.card_name }
    end
    @players[0].cards[1] = @cards.shift
    @players[0].cards[2] = @cards.shift
    @players[1].cards[1] = @cards.shift
    @players[1].cards[2] = @cards.shift
    @board.card << @cards.shift
  end

  def random_card
    Card.new(@@card_list[rand(0..15)])
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
    while true
      puts "#{@players[@current_player].name} it's your turn!"
      @board.print_board
      piece, card, to_pos = get_player_move
      move_piece(piece, to_pos)
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

    return [piece, card, to_pos]
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

    while true
      puts "#{message}#{options}"
      user_input = gets.chomp.downcase

      if options.keys.include?(user_input.to_i)
        puts "you chose #{options[user_input.to_i]}"
        return user_input
      else

        case user_input
          when "back", "restart", "r"
            #code to get to start of input
          when "exit", "quit", "q"
            quit_game
          when "cards", "card", "c"
            @players[@current_player].print_cards
            @board.print_card
            @players[(@current_player+1)%2].print_cards
          when "board", "b"
            @board.print_board
          when "help", "h"
            puts @@help_message
          when "rules", "r"
            link = "http://www.arcanewonders.com/resources/Onitama_Rulebook.PDF"
            if RbConfig::CONFIG['host_os'] =~ /mswin|mingw|cygwin/
              system "start #{link}"
            elsif RbConfig::CONFIG['host_os'] =~ /darwin/
              system "open #{link}"
            elsif RbConfig::CONFIG['host_os'] =~ /linux|bsd/
              system "xdg-open #{link}"
            end
          else
            puts input_error(user_input)
          end

        end

      end

  end

  def move_piece(piece, to_pos)
    check_to_pos(piece, to_pos)
    @board.move_piece(piece, to_pos)
  end

  def check_to_pos(piece, to_pos)
    piece_at_pos = @board.board[to_pos[0]][to_pos[1]]
    owner = piece_at_pos.owner
    case owner
      when @players[@current_player]
        puts "You can't take your own piece."
        play_turn
      when @players[(@current_player+1)%2]
        if piece_at_pos.number == 5
          @board.move_piece(piece, to_pos)
          declare_winner(@players[@current_player].name)
        end
        owner.remove_piece(piece_at_pos)
      else
        if to_pos == [0,2] && @players[@current_player].color == "black" && piece.number == 5
          @board.move_piece(piece, to_pos)
          declare_winner(@players[@current_player].name)
        elsif to_pos == [4,5] && @players[@current_player].color == "white" && piece.number == 5
          @board.move_piece(piece, to_pos)
          delcare_winner(@players[@current_player].name)
        end
        return
    end
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
    puts "#{player} has Won!"
    exit
  end

  # def game_end
  #   @board.print_board
  #   if @board.winner
  #     puts "Game Over! #{@board.winner} has won!"
  #   else
  #     puts "Exiting Game"
  #   end
  # end

  def quit_game
    puts "Exiting Game."
    exit
  end

  def input_error(input)
    return "#{input} is not a valid input"
  end
end
