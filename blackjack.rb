# super class - both dealer & players share name / scores / methods
class Gambler
  attr_accessor :name, :score

  def initialize(n,s)
    @name = n
    @score = s
  end

  def blackjack?
    if @score == 21
      return true
    else
      return false
    end
  end

  def bust?
    if @score > 21
      return true
    else
      return false
    end
  end
end

class Dealer < Gambler
  def ask_name
    "What is your name?"
  end
end

class Player < Gambler

end

class Deck
  attr_accessor :cards, :num_decks
  # set up suits & values as constants, they should never change
  SUITS = ['S', 'C', 'D', 'H']
  VALUES = ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K']

  # takes number of decks as input
  def initialize(n)
    @cards = []
    @num_decks = n
    @num_decks.times do 
      SUITS.each do |suit|
        VALUES.each do |value|
          @cards << Card.new(suit,value)
        end
      end
    end
  end

  def display_deck
      "#{cards}"
  end
  
  # returns shuffled array of cards, no matter how many cards there are
  def shuffle 
    @cards.shuffle
  end

  #takes how many cards to deal as input
  def deal(n)
    @num_cards = n
    @num_cards.times do
      @cards.pop
    end
  end
end

class Card 
  attr_accessor :suit, :value

  def initialize(s, v)
    @suit = s
    @value = v
  end

  def display_card
    "#{suit}, #{value}"
  end
end

# this is the "engine" that runs blackjack game
class Blackjack
  attr_accessor :num_players, :players

  def initialize(n)
    @num_players = n
    @dealer = Dealer.new('Dealer', 0)
    @players = [] 
    @num_players.times do
      puts @dealer.ask_name
      name = gets.chomp
      @players << Player.new(name, 0)
    end
  end

  def display_players
    "#{players}"
  end
end

# sets up game with number of players here, maybe ask how many playing instead
game = Blackjack.new(3)
players = game.display_players
puts players


