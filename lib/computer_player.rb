class ComputerPlayer

  @@pos_values_student = [[0.5, 0.8, 1.0, 0.8, 0.5],
                          [0.8, 0.9, 1.0, 0.9, 0.8],
                          [0.7, 1.0, 1.0, 1.0, 0.7],
                          [0.8, 0.9, 1.0, 0.9, 0.8],
                          [0.5, 0.8, 1.0, 0.8, 0.5]]


  @@pos_values_top_senei = [[0.5, 0.8, 1.0, 0.8, 0.5],
                            [0.6, 0.9, 1.1, 0.9, 0.6],
                            [0.7, 1.0, 1.2, 1.0, 0.7],
                            [0.8, 1.1, 1.3, 1.1, 0.8],
                            [0.9, 1.2, 1.4, 1.2, 0.9]]

  @@pos_values_bot_senei = [[0.9, 1.2, 1.5, 1.2, 0.9],
                            [0.8, 1.1, 1.3, 1.1, 0.8],
                            [0.7, 1.0, 1.2, 1.0, 0.7],
                            [0.6, 0.9, 1.1, 0.9, 0.6],
                            [0.5, 0.8, 1.0, 0.8, 0.5]]

  attr_reader :name, :side
  attr_accessor :pieces, :pieces_lost, :cards

  def initialize(name, side = 'bot')
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

  def get_player_move(board, opponent)
    max_value_move(board)[0]
  end

  def max_value_move(board)
    moves_by_value = all_moves_by_value(board)
    max_val = moves_by_value.max_by { |el| el[1] }[1]
    moves_by_value.select { |el| el[1] == max_val }.sample
  end

  def all_moves_by_value(board)
    moves_by_value = []
    @pieces.each do |_k, piece|
      @cards.each do |_k, card|
        moves = piece.available_moves(card)
        moves.each do |_k, move|
          next if !board[move].nil? && board[move].side == @side
          board_value = board_value_after_move(board, piece, move)
          moves_by_value << [[piece, card, move], board_value]
        end
      end
    end
    moves_by_value
  end

  def board_value_after_move(board, piece, move)
    from_pos = piece.position
    board_copy = board.copy
    board_copy.move_piece(piece, move)
    board_value = board_value(board_copy)
    board_copy.move_piece(piece, from_pos)
    board_value
  end

  def board_value(board)
    value = 0
    board.grid.each_index do |row|
      board.grid[row].each_index do |col|
        value += pos_value(board, [row, col])
      end
    end
    value
  end

  def pos_value(board, pos)
    piece = board[pos]
    return 0 if piece.nil?
    value_matrix = value_matrix_to_use(piece)
    scale_factor = scale_factor_to_use(piece)
    value_matrix[pos[0]][pos[1]] * scale_factor
  end

  def value_matrix_to_use(piece)
    if piece.number != 5
      return @@pos_values_student
    end
    if piece.side == "top"
      return @@pos_values_top_senei
    elsif piece.side == "bot"
      return @@pos_values_bot_senei
    end
  end

  def scale_factor_to_use(piece)
    scale_factor = piece.side != @side ? -2 : 1
    scale_factor *= 10 if piece.side != @side && piece.number == 5
    scale_factor
  end

  def print_cards
    res = "\t#{@name}'s Cards: \n"
    @cards.each { |_, card| res += "\t{#{card.name}: #{card.moves}} \n" }
    puts res
  end

end
