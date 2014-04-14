# super class - both dealer & players share name / scores / status method
class Gambler
  attr_accessor :name, :score, :status

  def initialize(n,s)
    @name = n
    @score = s
  end

  # takes current score as input - returns blackjack/bust as string or current score if neither, kinda sloppy maybe rethink this
  def status(s)
    status = s
    if s == 21
      status = 'blackjack'
    elsif s > 21
      status = 'bust'
    end
    status
  end
end

class Dealer < Gambler
  # speaks, takes what to speak string as input
  def speak(s)
    case s 
      when 'welcome'
        'My name is #{name}. Welcome to the casino!!!'
      when 'name'
        'What is your name?'
      when 'play'
        'Shoud we play another game?'
      when 'hit'
        'Do you want to hit or not?'
    end
  end
end

class Player < Gambler
  attr_accessor :play_again
  
  def round(s)

  end
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
      SUITS.each do |s|
        VALUES.each do |v|
          @cards << Card.new(s,v)
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

  #takes any number cards to deal as input, returns the dealt cards
  def deal(n)
    @dealt_cards = []
    n.times {@dealt_cards << @cards.pop}
    @dealt_cards
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

# this is the "engine" that runs blackjack game, takes number of players as input
class Blackjack
  attr_accessor :num_players, :players, :deck

  def initialize(n)
    @num_players = n
    @dealer = Dealer.new('Frank', 0)
    @players = []
    @num_games = 0
    if @num_games == 0
      puts @dealer.speak('welcome')
    end
    player_id = 1
    @num_players.times do
      puts "Player #{player_id}, " + @dealer.speak('name')
      name = gets.chomp
      @players << Player.new(name, 0)
      player_id += 1
    end
    @deck = Deck.new(4)
  end

  # players take turns
  def player_rounds
    @players.each do |p| 
     p.round
    end
  end
  
  def display_players
    "#{players}"
  end
end

# sets up game with number of players here, maybe ask how many playing instead

game = Blackjack.new(3)
puts game.display_players



