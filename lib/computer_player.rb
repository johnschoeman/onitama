class ComputerPlayer

  @@board_pos_weight = [[1.0, 2.0, 5.0, 2.0, 1.0],
                        [2.0, 3.0, 4.0, 3.0, 2.0],
                        [2.0, 3.0, 5.0, 3.0, 2.0],
                        [2.0, 3.0, 4.0, 3.0, 2.0],
                        [1.0, 2.0, 5.0, 2.0, 1.0]]

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

  def get_player_move(board, opponent)
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

  def max_value_move(board)

  end

  def all_moves_by_value(board)
    moves = []
    @pieces.each do |piece|
      @cards.each do |card|
        piece.available_moves(card).each do |move|
          board_dup = board.dup
          to_pos = piece.to_pos(move)
          board_dup.move_piece(piece, to_pos)
          board_value = board_value(board_dup)
          moves << [[piece, card, move], board_value]
        end
      end
    end
    moves
  end

  def board_value(board)
    value = 0
    board.grid.each_index do |row|
      board.grid[row].each_index do |col|
        piece = board[[row, col]]
        next if board[[row, col]].nil?
        if piece.color != @color
          value -= @@board_pos_weight[row][col] * piece.value
        elsif piece.color == @color
          value += @@board_pos_weight[row][col] * piece.value
        end
      end
    end
    value
  end

end
