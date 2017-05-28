require_relative "onitama"
require "test/unit"

class TestOnitama < Test::Unit::TestCase

  def setup
    @game = Onitama.new()
  end

  def teardown

  end

  def test_setup_players
    assert_not_nil(@game.players)
  end

  def test_pieces
    @games.players[0].pieces.each do |num, piece|
      assert_equal(piece.class, "Piece")
    end
  end

  # def test_quit_game
  #   assert_equal(@game.quit_game, nil)
  # end

end
