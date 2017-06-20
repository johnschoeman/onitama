class ComputerPlayer

  @@board_pos_weight = [[0.5, 0.8, 1.0, 0.8, 0.5],
                        [0.8, 0.9, 1.0, 0.9, 0.8],
                        [0.7, 1.0, 1.0, 1.0, 0.7],
                        [0.8, 0.9, 1.0, 0.9, 0.8],
                        [0.5, 0.8, 1.0, 0.8, 0.5]]

  # @@board_pos_weight = [[0.9, 1.2, 1.5, 1.2, 0.9],
  #                       [0.8, 1.1, 1.3, 1.1, 0.8],
  #                       [0.7, 1.0, 1.2, 1.0, 0.7],
  #                       [0.6, 0.9, 1.1, 0.9, 0.6],
  #                       [0.5, 0.8, 1.0, 0.8, 0.5]]

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

  def get_selection(options)
    options.keys.sample
  end

  def get_player_move(board, opponent)
    piece_num, card_num, move_num = max_value_move(board)[0]
    piece = get_piece_by_num(piece_num)
    card = get_card_by_num(card_num)
    to_pos = piece.available_moves(card)[move_num]
    [piece, card, to_pos]
  end

  def max_value_move(board)
    moves_by_value = all_moves_by_value(board)
    max_val = moves_by_value.max_by { |el| el[1] }[1]
    moves_by_value.select { |el| el[1] == max_val }.sample
  end

  def all_moves_by_value(board)
    moves_by_value = []
    @pieces.each do |k_piece, piece|
      next if piece.nil?
      @cards.each do |k_card, card|
        moves = piece.available_moves(card)
        moves.each do |k_move, move|
          from_pos = piece.position
          board_copy = board.copy
          if !board_copy[move].nil?
            next if board_copy[move].color == @color
          end
          board_copy.move_piece(piece, move)
          board_value = board_value(board_copy)
          board_copy.move_piece(piece, from_pos)
          moves_by_value << [[k_piece, k_card, k_move], board_value]
        end
      end
    end
    moves_by_value
  end

  def board_value(board)
    value = 0
    board.grid.each_index do |row|
      board.grid[row].each_index do |col|
        piece = board[[row, col]]
        next if board[[row, col]].nil?
        if piece.color != @color
          value -= @@board_pos_weight[row][col] * piece.value * 2
        elsif piece.color == @color
          value += @@board_pos_weight[row][col] * piece.value
        end
      end
    end
    value
  end

  def print_cards
    res = "\t#{@name}'s Cards: \n"
    @cards.each { |_, card| res += "\t{#{card.name}: #{card.moves}} \n" }
    puts res
  end

end
