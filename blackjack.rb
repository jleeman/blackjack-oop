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

  # display total in user friendly fashion
  def display_total (person)
    puts "#{person.name}'s total is #{person.hand_value(person.hand)}."  
  end

  # display cards in user friendly fashion, need to take account dealer exception, add later
  def display_cards (cards, name)
    puts "#{name} has been dealt:"
    cards.each do |card|
      puts "#{card.value} of #{card.suit}"
    end  
  end

  # boolean for blackjack
  def blackjack? (hand_value)
    hand_value == 21? true : false
  end

  # boolean for bust
  def bust? (hand_value)
    hand_value > 21? true : false
  end
end

class Player < CasinoPerson
  # player round, returns value of player hand, exits if blackjack or bust
  def p_round (dealer, player, deck)
    # result of first deal
    hand_value = player.hand_value(player.hand)
    player.display_cards(player.hand, player.name)
    player.display_total(player)
    # go into hit stay loop, but only if no blackjack
    if player.blackjack?(hand_value) != true 
      hit_stay = dealer.q_a("Would you like to hit or stay? hit/stay response only.")
      while hit_stay == "hit"
        player.hand << deck.cards.pop
        hand_value = player.hand_value(player.hand)
        player.display_cards(player.hand, player.name)
        player.display_total(player)
        if player.blackjack?(hand_value) || player.bust?(hand_value)
          break
        else
          hit_stay = dealer.q_a("Would you like to hit or stay? hit/stay response only.")
        end
      end        
    end
    hand_value
  end
end

class Dealer < CasinoPerson
  # dealer round, return value of dealer hand
  def d_round (dealer, player, deck)
    puts "Dealer playing round now..."
    hand_value = dealer.hand_value(dealer.hand)
    dealer.display_cards(dealer.hand, dealer.name)
    dealer.display_total(dealer)
      while hand_value <= 17
        puts "Dealing one more card..."
        dealer.hand << deck.cards.pop
        dealer.display_cards(dealer.hand, dealer.name)
        dealer.display_total(dealer)
        hand_value = dealer.hand_value(dealer.hand)
      end
    hand_value
  end

  # input is string question, output is string answer
  def q_a (q)
    puts "#{q}"
    a = gets.chomp
  end
end

class Deck
  attr_accessor :cards
  
  def initialize
    suits = ['Spades', 'Clubs', 'Diamonds', 'Hearts']
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

  def initialize (s, v)
    @suit = s
    @value = v
  end
end

# this is the "engine" that runs blackjack game
class Blackjack

  def initialize
    @play_again = true 
    dealer = Dealer.new("Dealer")
    player_name = dealer.q_a("Welcome to the casino! What's your name?")
    player = Player.new("#{player_name}")
    deck = Deck.new
    play_game(dealer, player, deck)
  end

  # plays one full game
  def play_game (dealer, player, deck)
    # initial deal
    2.times do
      player.hand << deck.cards.pop
      dealer.hand << deck.cards.pop
    end
    # player round
    p_value = player.p_round(dealer, player, deck)
    d_value = 0
    # evaluate player for blackjack/bust before dealer plays round
    if (player.blackjack?(p_value) != true) &&  (player.bust?(p_value) != true)
      # dealer round
      d_value = dealer.d_round(dealer, player, deck)
    end
    evaluate(dealer, player, d_value, p_value)
  end

  # evaluates, displays outcome
  def evaluate (dealer, player, d_value, p_value)
    if player.blackjack?(p_value)
      puts "Blackjack!!! You win!"
    elsif player.bust?(p_value)
      puts "You went bust! Bummer."
    elsif dealer.bust?(d_value)
      puts "Dealer hit bust!!! You win!"
    elsif d_value > p_value
      puts "Dealer total greater than yours. Sorry, you lost."
    elsif p_value > d_value
      puts "Player total greater than dealers. You win!"
    elsif p_value == d_value
      puts "It's a push!"
    end
  end
end

game = Blackjack.new




