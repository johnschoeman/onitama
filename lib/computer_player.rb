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

  def print_cards
    res = "\t#{@name}'s Cards: \n"
    @cards.each { |k, card| res += "\t{#{card.name}: #{card.moves}} \n" }
    puts res
  end

  def get_player_move(_, _)
    piece_num = get_piece_selection
    piece = get_piece_by_num(piece_num.to_i)

    card_num = get_card_selection(piece)
    card = get_card_by_num(card_num.to_i)

    to_pos_num = get_move_selection(piece, card)
    to_pos = piece.available_moves(card)[to_pos_num.to_i]

    [piece, card, to_pos]
  end

  def get_piece_selection
    get_selection(@pieces)
  end

  def get_card_selection(_)
    get_selection(@cards)
  end

  def get_move_selection(piece, card)
    get_selection(piece.available_moves(card))
  end

  def get_selection(options)
    options.keys.sample
  end
end
