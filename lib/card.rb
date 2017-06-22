class Card

  @@card_dic = {
    tiger:    [[2, 0], [-1, 0]],
    dragon:   [[0, -2], [0, 2], [-1, 1], [-1, -1]],
    crab:     [[1, 0], [0, 2], [0, -2]],
    elephant: [[1, -1], [1, 1], [0, -1], [0, 1]],
    monkey:   [[1, -1], [1, 1], [-1, 1], [-1, -1]],
    mantis:   [[1, -1], [1, 1], [-1, 0]],
    crane:    [[1, 0], [-1, 1], [-1, -1]],
    boar:     [[1, 0], [0, -1], [0, 1]],
    frog:     [[0, -2], [1, -1], [-1, 1]],
    rabbit:   [[-1, -1], [1, 1], [0, 2]],
    goose:    [[1, -1], [0, -1], [0, 1], [-1, 1]],
    rooster:  [[-1, -1], [0, -1], [0, 1], [1, -1]],
    horse:    [[1, 0], [0, -1], [-1, 0]],
    ox:       [[1, 0], [0, 1], [-1, 0]],
    eel:      [[1, -1], [0, 1], [-1, -1]],
    cobra:    [[0, -1], [1, 1], [1, -1]]
  }

  attr_reader :name, :moves

  def initialize(name)
    @name = name
    @moves = @@card_dic[@name]
  end

  def print_card
    @name.to_s
  end

  def self.initial_cards
    cards = []
    while cards.length < 5
      card = Card.new(@@card_dic.keys.sample)
      cards.push(card) if cards.none? { |c| c.name == card.name }
    end
    cards
  end

  def self.setup_cards(top_player, bot_player, board)
    cards = self.initial_cards
    top_player.cards[1] = cards.shift
    top_player.cards[2] = cards.shift
    bot_player.cards[1] = cards.shift
    bot_player.cards[2] = cards.shift
    board.card = []
    board.card << cards.shift
  end

  def copy
    Card.new(@name)
  end

end
