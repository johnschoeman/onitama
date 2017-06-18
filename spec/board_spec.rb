require 'rspec'
require 'onitama'

describe Board do
  let(:empty_board) { Board.new }
  let(:test_board) { Board.new }

  describe "#move_piece" do
    before do
      piece = double("piece")
      allow(piece).to receive(:position).and_return([1, 1])
      allow(piece).to receive(:position=)
      test_board.place_piece(piece, [1, 1])
    end

    it "moves a piece" do
      #byebug
      piece_to_move = test_board[[1, 1]]
      test_board.move_piece(piece_to_move, [2, 2])
      expect(test_board[[2, 2]]).to eql(piece_to_move)
      expect(test_board[[0, 0]]).to eql(nil)
      expect(test_board[[1, 1]]).to eql(nil)
    end
  end

  describe "#print_board" do

  end
end
