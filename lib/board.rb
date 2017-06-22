class Board
  attr_accessor :grid, :card

  def initialize
    @grid = Array.new(5) { Array.new(5) { nil } }
    @card = [nil]
  end

  def [](pos)
    row, col = pos
    @grid[row][col]
  end

  def []=(pos, piece)
    row, col = pos
    @grid[row][col] = piece
  end

  def setup_pieces(top_player, bot_player)
    @grid = Array.new(5) { Array.new(5) { nil } }
    place_piece(top_player.get_piece_by_num(5), [0, 2])
    place_piece(bot_player.get_piece_by_num(5), [4, 2])
    (1..4).each do |n|
      if n == 1 || n == 2
        place_piece(top_player.get_piece_by_num(n), [0, n - 1])
        place_piece(bot_player.get_piece_by_num(n), [4, n - 1])
      else
        place_piece(top_player.get_piece_by_num(n), [0, n])
        place_piece(bot_player.get_piece_by_num(n), [4, n])
      end
    end
  end

  def print_board
    puts ""
    puts "     |  0   1   2   3   4  |  "
    puts "   " + "-" * 27
    @grid.each_with_index do |row, i|
      temp = "   #{i} | "
      row.each do |col|
        if col.nil?
          temp += "--- "
          next
        end
        temp += "#{col.print_piece} "
      end
      temp += "| #{i}"
      puts temp
    end
    puts "   " + "-" * 27
    puts "     |  0   1   2   3   4  |  "
    puts ""
  end

  def print_card
    res = "\tBoard Card: \n"
    res += "\t{#{@card[0].name}: #{@card[0].moves}} \n"
    puts res
  end

  def place_piece(piece, to_pos)
    self[to_pos] = piece
    piece.position = to_pos
  end

  def remove_piece(pos)
    self[pos] = nil
  end

  def move_piece(piece, to_pos)
    remove_piece(piece.position)
    place_piece(piece, to_pos)
  end


  def copy
    new_board = Board.new
    self.grid.each_index do |row|
      self.grid.each_index do |col|
        next if self[[row, col]].nil?
        new_piece = self[[row, col]].dup
        new_board.place_piece(new_piece, [row, col])
      end
    end
    new_board
  end

end
