class Piece
  attr_reader :side, :number, :value
  attr_accessor :position
  #if @number == 0 the piece is a Sensei(King Piece)
  #if @number is 1,2,3 or 4 the piece is a pawn
  def initialize(side, number, value = 1.0)
    @side = side
    @number = number
    @value = value
    @position = nil
  end

  def self.initial_pieces(side)
    {
      1 => Piece.new(side, 1),
      2 => Piece.new(side, 2),
      3 => Piece.new(side, 3),
      4 => Piece.new(side, 4),
      5 => Piece.new(side, 5)
    }
  end

  def print_piece
    if @side == "top"
      @number == 5 ? "<*>" : "<#{@number}>"
    elsif @side == "bot"
      @number == 5 ? "[*]" : "[#{@number}]"
    end
  end

  def print_name
    @number == 5 ? "*" : @number.to_s
  end

  def available_moves(card)
    res = {}
    all_moves = card.moves.map { |move| self.to_pos(move) }
    moves_on_board = all_moves.select do |move|
      (0..4).include?(move[0]) && (0..4).include?(move[1])
    end
    moves_on_board.each_with_index { |move, i| res[i + 1] = move }
    res
  end

  def to_pos(move)
    if @side == "top"
      [@position[0] + move[0], @position[1] + move[1]]
    elsif @side == "bot"
      [@position[0] - move[0], @position[1] - move[1]]
    end
  end
end
