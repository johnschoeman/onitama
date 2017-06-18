class ComputerPlayer
  attr_reader :name, :color
  attr_accessor :pieces, :pieces_lost, :cards

  def initialize(name, color = 'black')
    @name = name
    @color = color
    @pieces = Piece.initial_pieces(color)
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

  def get_piece_by_name(name)
    case name
    when "1", "2", "3", "4"
      return @pieces[name.to_i]
    when "s", "S"
      return @pieces[0]
    else
      choice_error(name)
    end
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
    @cards.each { |k, card| res[k] = card.print_card + ": #{piece.available_moves_as_array(card)}"}
    res
  end

  def print_cards
    res = "\t#{@name}'s Cards: \n"
    @cards.each {|k, card| res += "\t{#{card.name}: #{card.moves}} \n"}
    puts res
  end

  def get_player_move(_, _)
    piece_num = get_piece_selection
    piece = get_piece_by_num(piece_num.to_i)

    card_num = get_card_selection(piece)
    card = get_card_by_num(card_num.to_i)

    to_pos_num = get_move_selection(piece, card)
    to_pos = piece.available_moves_as_hash(card)[to_pos_num.to_i]

    [piece, card, to_pos]
  end

  def get_piece_selection
    get_selection(available_pieces)
  end

  def get_card_selection(piece)
    get_selection(available_cards_with_moves(piece))
  end

  def get_move_selection(piece, card)
    get_selection(piece.available_moves_as_hash(card))
  end

  # input must be a hash.
  def get_selection(options)
    options.keys.sample
  end
end
