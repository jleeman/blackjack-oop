require 'pry'

class Card 
  attr_accessor :suit, :value

  def initialize(s, v)
    @suit = s
    @value = v
  end

  def display
    puts "#{@value} of #{@suit}"
  end
end

class Deck
  attr_accessor :cards
  
  def initialize(n)
    suits = ['Spades', 'Clubs', 'Diamonds', 'Hearts']
    values = ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K']
    @cards = []
    n.times do
      suits.each do |s|
        values.each do |v|
          @cards << Card.new(s, v)
        end
      end
    end
    @cards.shuffle!
  end

  def first_deal(dealer, players)
    2.times do
      players.each do |p| 
        p.hand << deal_card
      end 
      dealer.hand << deal_card
    end
  end

  def deal_card
    cards.pop
  end
end

module Hand
  def display_hand(n, h)
    puts "#{n} has:"
    h.each do |c|
      c.display
    end
  end

  def total(h)
    h_value = 0
    h.each do |card|
      case card.value
        when /[2-9]|[1][0]/ 
          h_value += card.value.to_i 
        when /[JQK]/
          h_value += 10
        when "A"
          h_value += 11
          if h_value > 21
            h_value -= 10 
          end 
      end
    end
    h_value
  end

  def blackjack?(h)
    h == 21
  end

  def bust?(h)
    h > 21
  end
end

class Player
  include Hand
  attr_accessor :name, :hand, :chips, :wager

  def initialize(n, c)
    @name = n
    @hand = []
    @chips = c
    @wager = 0
  end
end

class Dealer
  include Hand
  attr_accessor :hand, :chips
  
  def initialize
    @name = "Dealer"
    @hand = []
    @chips = 0
  end
end

class Blackjack

  def initialize
    deck = setup_decks
    puts "#{deck.cards.length}"
    players = []
    players = setup_players(players)
    dealer = Dealer.new
    play(deck, players, dealer)
  end

  def play(deck, players, dealer)
    deck.first_deal(dealer, players)
    player_rounds(deck, players, dealer)
  end

  def player_rounds(deck, players, dealer)
    players.each do |p|
      total = p.total(p.hand)
      puts "Dealer is showing a #{dealer.hand[01].value}."
      puts "---"
      p.display_hand(p.name, p.hand)
      puts "---"
      if blackjack?(p.hand)
        puts "Blackjack! You win."
        break
      else
      puts "#{p.name} has a total of #{total}"
      puts "#{p.name}, would you like to hit or stay?"
    end
  end

  def setup_players(players)
    num_players = q_a("How many players?").to_i
    i = 1
    num_players.times do
      n = q_a("Player #{i}, what is your name?")
      c = q_a("#{n}, how many chips do you have? (numbers only)").to_i
      players << Player.new(n, c)
      i += 1 
    end
    players
  end

  def setup_decks
    num_decks = q_a("How many decks to use?").to_i
    Deck.new(num_decks)
  end

  def q_a (q)
    puts q
    a = gets.chomp 
  end
 
end

game = Blackjack.new




