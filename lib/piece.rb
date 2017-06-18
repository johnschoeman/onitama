class Piece
  attr_reader :owner, :color, :number
  attr_accessor :position
  #if @number == 0 the piece is a Sensei(King Piece)
  #if @number is 1,2,3 or 4 the piece is a pawn
  def initialize(owner, number)
    @owner = owner
    @color = @owner.color
    @number = number
  end

  def self.initial_pieces(owner)
    {
      1 => Piece.new(owner, 1),
      2 => Piece.new(owner, 2),
      3 => Piece.new(owner, 3),
      4 => Piece.new(owner, 4),
      5 => Piece.new(owner, 5)
    }
  end

  def print_piece
    if @color == "white"
      @number == 5 ? ">*<" : ">#{@number}<"
    else
      @number == 5 ? "<*>" : "<#{@number}>"
    end
  end

  def print_name
   @number == 5 ? "*" : @number.to_s
  end

  # returns valid moves of piece at current position as array, selects only those that fall onto board.
  def available_moves_as_array(card)
    if @color == "white"
      res = card.moves.map { |move| [@position[0] + move[0], @position[1] + move[1]] }
      res.select { |move| (0..4).include?(move[0]) && (0..4).include?(move[1]) }
    else
      res = card.moves.map { |move| [@position[0] - move[0], @position[1] - move[1]] }
      res.select { |move| (0..4).include?(move[0]) && (0..4).include?(move[1]) }
    end
  end

  # returns valid moves of piece at current position as hash, selects only those that fall onto board.
  def available_moves_as_hash(card)
    res = {}
    if @color == "white"
      all_moves = card.moves.map { |move| [@position[0] + move[0], @position[1] + move[1]] }
      moves_on_board = all_moves.select { |move| (0..4).include?(move[0]) && (0..4).include?(move[1]) }
      moves_on_board.each_with_index { |move, i| res[i+1] = move}
    else
      all_moves = card.moves.map { |move| [@position[0] - move[0], @position[1] - move[1]] }
      moves_on_board = all_moves.select { |move| (0..4).include?(move[0]) && (0..4).include?(move[1]) }
      moves_on_board.each_with_index { |move, i| res[i+1] = move}
    end
    res
  end
end
