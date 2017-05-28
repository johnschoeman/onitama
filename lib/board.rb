class Board
  attr_reader :board
  attr_accessor :card
  def initialize
    @board = Array.new(5){Array.new(5){Piece.new()}}
    @card = []
  end

  def print_board
    puts ""
    puts "     |  0   1   2   3   4  |  "
    puts "   "+"-"*27
    @board.each_with_index do |row, i|
      temp = "   #{i} | "
      row.each do |col|
        temp += "#{col.print_piece} "
      end
      temp += "| #{i}"
      puts temp
    end
    puts "   "+"-"*27
    puts "     |  0   1   2   3   4  |  "
    puts ""
  end

  def print_card
    res = "\tBoard Card: \n"
    res += "\t{#{@card[0].card_name}: #{@card[0].moves}} \n"
    puts res
  end

  def place_piece(piece,to_pos)
    @board[to_pos[0]][to_pos[1]] = piece
    piece.position = to_pos
  end

  def remove_piece(pos)
    @board[pos[0]][pos[1]] = Piece.new()
  end

  def move_piece(piece,to_pos)
    remove_piece(piece.position)
    place_piece(piece,to_pos)
  end

  def winner

  end

  def place_error(pos)

  end

end
