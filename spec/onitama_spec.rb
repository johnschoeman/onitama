require 'rspec'
require 'byebug'
require 'onitama'

describe Onitama do
  let(:player1) { HumanPlayer.new("player1", "top") }
  let(:player2) { HumanPlayer.new("player2", "bot") }
  let(:game) { Onitama.new(player1, player2) }

  let(:top_sensei) { Piece.new("top", 5) }
  let(:bot_sensei) { Piece.new("bot", 5) }

  let(:top_student1) { Piece.new("top", 1) }
  let(:top_student2) { Piece.new("top", 2) }
  let(:bot_studnet) { Piece.new("bot", 1) }

  describe "#move_is_valid?" do
    before do
      game.board.place_piece(top_student1, [0, 0])
      game.board.place_piece(top_student2, [0, 1])
    end
    it "returns true if move is valid" do
      expect(game.move_is_valid?(top_student1, [1, 1])).to be_truthy
    end

    it "returns false if move tries to take own piece" do
      expect(game.move_is_valid?(top_student1, [0, 1])).to be_falsey
    end
  end

  describe "#move_ends_game?" do
    before do
      game.board.place_piece(top_sensei, [4, 1])
      game.board.place_piece(bot_sensei, [2, 2])
      game.board.place_piece(top_student1, [2, 1])
      allow(top_sensei).to receive(:number).and_return(5)
      allow(bot_sensei).to receive(:number).and_return(5)
    end
    it "returns true if Senesi is captured" do
      expect(game.move_ends_game?(top_student1, [2, 2])).to be_truthy
    end

    it "returns true if Senesi takes enemy temple" do
      expect(game.move_ends_game?(top_sensei, [4, 2])).to be_truthy
      expect(game.move_ends_game?(bot_sensei, [0, 2])).to be_truthy
    end

    it "returns false if neither Sensei or temple is taken" do
      expect(game.move_ends_game?(top_sensei, [3, 3])).to be_falsey
    end
  end

  describe "#move_takes_piece?" do
    it "returns true if move takes a piece" do

    end

    it "returns false if move does not take a piece" do

    end
  end
end
