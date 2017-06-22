class HumanPlayer

  @@help_message = "\tType 'board' or 'b' to show the board
  \tType 'cards' or 'c' to show your available cards
  \tType 'quit' or 'q' to exit
  \tType 'help' or 'h' for help
  \tType 'rules' or 'r' for rules"

  attr_reader :name, :side
  attr_accessor :pieces, :pieces_lost, :cards

  def initialize(name, side = 'top')
    @name = name
    @side = side
    @pieces = Piece.initial_pieces(side)
    @pieces_lost = []
    @cards = {}
  end

  def remove_piece(piece)
    puts "#{@name} has lost #{piece.print_piece}"
    @pieces_lost << piece
    @pieces.delete(piece.number)
  end

  def get_piece_by_num(num)
    @pieces[num]
  end

  def get_card_by_num(num)
    @cards[num]
  end

  def available_pieces
    res = {}
    @pieces.each { |k, piece| res[k] = piece.print_piece }
    res
  end

  def available_cards
    res = {}
    @cards.each { |k, card| res[k] = card.print_card }
    res
  end

  def available_cards_with_moves(piece)
    res = {}
    @cards.each do |k, card|
      res[k] = card.print_card + ": #{piece.available_moves(card).values}"
    end
    res
  end

  def print_cards
    res = "\t#{@name}'s Cards: \n"
    @cards.each {|k, card| res += "\t{#{card.name}: #{card.moves}} \n"}
    puts res
  end

  def get_player_move(board = nil, opponent = nil)
    piece_num = get_piece_selection(board, opponent)
    piece = get_piece_by_num(piece_num.to_i)

    card_num = get_card_selection(piece, board, opponent)
    card = get_card_by_num(card_num.to_i)

    to_pos_num = get_move_selection(piece, card, board, opponent)
    to_pos = piece.available_moves(card)[to_pos_num.to_i]

    [piece, card, to_pos]
  end

  def get_piece_selection(board = nil, opponent = nil)
    get_selection("Choose piece: ", available_pieces, board, opponent)
  end

  def get_card_selection(piece, board = nil, opponent = nil)
    get_selection("Choose card: ", available_cards_with_moves(piece), board, opponent)
  end

  def get_move_selection(piece, card, board = nil, opponent = nil)
    get_selection("Choose move: ", piece.available_moves(card), board, opponent)
  end

  # input must be a hash.
  def get_selection(message, options, board, opponent)
    loop do
      puts "#{message}#{options}"
      user_input = gets.chomp.downcase
      if options.keys.include?(user_input.to_i)
        puts "you chose #{options[user_input.to_i]}"
        return user_input
      else
        handle_non_move_choice(user_input, board, opponent)
      end
    end
  end

  def handle_non_move_choice(user_input, board, opponent)

    case user_input
    when "back", "restart", "r"
      #code to get to start of input
    when "exit", "quit", "q"
      quit_game
    when "cards", "card", "c"
      print_cards
      board.print_card
      opponent.print_cards
    when "board", "b"
      board.print_board
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

  def quit_game
    puts "Exiting Game."
    exit
  end
end
