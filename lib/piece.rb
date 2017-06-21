class Piece
  attr_reader :color, :number, :value
  attr_accessor :position
  #if @number == 0 the piece is a Sensei(King Piece)
  #if @number is 1,2,3 or 4 the piece is a pawn
  def initialize(color, number, value = 1.0)
    @color = color
    @number = number
    @value = value
    @position = nil
  end

  def self.initial_pieces(color)
    {
      1 => Piece.new(color, 1),
      2 => Piece.new(color, 2),
      3 => Piece.new(color, 3),
      4 => Piece.new(color, 4),
      5 => Piece.new(color, 5)
    }
  end

  def print_piece
    if @color == "white"
      @number == 5 ? ">*<" : ">#{@number}<"
    elsif @color == "black"
      @number == 5 ? "<*>" : "<#{@number}>"
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
    if @color == "white"
      [@position[0] + move[0], @position[1] + move[1]]
    elsif @color == "black"
      [@position[0] - move[0], @position[1] - move[1]]
    end
  end
end
