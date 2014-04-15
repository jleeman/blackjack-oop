require 'pry'

# super class for player/dealer, put methods/variables they share in common here
class CasinoPerson
  attr_accessor :name, :hand

  def initialize (name)
    @name = name
    @hand = []
  end

  # return hand value as integer at any time
  def hand_value (hand)
    hand_value = 0
    hand.each do |card|
      case card.value
        when /[2-9]|[1][0]/ 
          hand_value += card.value.to_i 
        when /[JQK]/
          hand_value += 10
        when "A"
          hand_value += 11
          if hand_value > 21
            hand_value -= 10 
          end 
      end
    end
    hand_value
  end

  # boolean for blackjack
  def blackjack? (hand_value)
    if hand_value == 21
      return true
    else
      return false
    end
  end

  # boolean for bust
  def bust? (hand_value)
    if hand_value > 21
      return true
    else
      return false
    end
  end

end

class Player < CasinoPerson

  def round (player, deck)
    hand_value = player.hand_value(player.hand)
    puts "You have been dealt #{player.hand}. Your current hand value is #{hand_value}."
    if player.blackjack?(hand_value) != true 
      puts "Would you like to hit or stay? hit/stay response only."
      hit_stay = gets.chomp.downcase
      while hit_stay == "hit"
        card = deck.cards.pop
        player.hand << card
        hand_value = player.hand_value(player.hand)
        if player.blackjack?(hand_value) || player.bust?(hand_value)
          break
        else
          puts "You have been dealt #{card.value}. Your current hand value is #{hand_value}."
          puts "Would you like to hit or stay? hit/stay response only."
          hit_stay = gets.chomp.downcase
        end
      end        
    end
    hand_value
  end

end

class Dealer < CasinoPerson

  def get_name
    puts "Welcome to the casino!"
    puts "What's your name?"
    player_name = gets.chomp
  end

end

class Deck
  attr_accessor :cards
  
  def initialize
    suits = ['S', 'C', 'D', 'H']
    values = ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K']
    @cards = []
    suits.each do |s|
      values.each do |v|
        @cards << Card.new(s, v)
      end
    end
    @cards.shuffle!
  end
end

class Card 
  attr_accessor :suit, :value

  def initialize(s, v)
    @suit = s
    @value = v
  end
end

# this is the "engine" that runs blackjack game
class Blackjack

  def initialize 
    dealer = Dealer.new("Dealer")
    player_name = dealer.get_name
    player = Player.new("#{player_name}")
    deck = Deck.new
    play_game(dealer, player, deck)
    # card_value = @deck.cards[1].value
    # puts "#{card_value}"
  end

  def play_game (dealer, player, deck)
    # initial deal
    2.times do
      player.hand << deck.cards.pop
      dealer.hand << deck.cards.pop
    end
    player_hand = player.hand
    dealer_hand = dealer.hand
    puts "Player hand is #{player_hand}"
    puts "Dealer hand is #{dealer_hand}"
    player_hand_value = player.round(player, deck)
    puts "#{player_hand_value}"
  end
end

game = Blackjack.new

