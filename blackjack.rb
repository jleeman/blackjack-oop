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

  def blackjack_or_bust?(h)
    h == 21 || h > 21
  end
end

class Player
  include Hand
  attr_accessor :name, :hand, :chips, :wager, :hand_total, :winner

  def initialize(n)
    @name = n
    @hand = []
    @chips = 50
    @wager = 0
    @hand_total = 0
    @winner = false
  end
end

class Dealer
  include Hand
  attr_accessor :name, :hand, :chips, :hand_total
  
  def initialize
    @name = "Dealer"
    @hand = []
    @chips = 0
    @hand_total = 0
  end
end

class Blackjack

  def initialize
    deck = setup_decks
    players = []
    players = setup_players(players)
    dealer = Dealer.new
    play(deck, players, dealer)
  end

  # set up players array and store names
  def setup_players(players)
    num_players = q_a("How many players?").to_i
    i = 1
    num_players.times do
      n = q_a("Player #{i}, what is your name?")
      players << Player.new(n)
      i += 1 
    end
    players
  end

  def setup_decks
    num_decks = q_a("How many decks to use?").to_i
    Deck.new(num_decks)
  end

  # game flow logic happens here
  def play(deck, players, dealer)
    deck.first_deal(dealer, players)
    player_rounds(deck, players, dealer)
    if dealer_round?(players)
      dealer_round(deck, dealer)
    end
    evaluate_winners(players, dealer)
  end

  # player rounds happen
  def player_rounds(deck, players, dealer)
    players.each do |p|
      p.wager = q_a("#{p.name}, How much would you like to wager this round?").to_i
    end
    players.each do |p|
      p.hand_total = p.total(p.hand)
      puts "---"
      puts "Dealer is showing a #{dealer.hand[01].value}."
      p.display_hand(p.name, p.hand)
      puts "Total is #{p.hand_total}"
      puts "---"
      if p.blackjack?(p.hand)
        puts "#{p.name} hit blackjack!"
      else
        hit_stay(p, deck)
        if p.blackjack?(p.hand_total)
          puts "#{p.name} hit Blackjack!"
        elsif p.bust?(p.hand_total)
          puts "Bust! Sorry, #{p.name} lost."
        end
      end
    end
    players
  end

  def dealer_round(deck, dealer)
    dealer.hand_total = dealer.total(dealer.hand)
    puts "Beginning dealer round..."
    puts "---"
    dealer.display_hand(dealer.name, dealer.hand)
    puts "Total is #{dealer.hand_total}."
    puts "---"
    if dealer.blackjack?(dealer.hand)
      puts "Blackjack! #{dealer.name} wins!"
    else
      while dealer.hand_total <= 17 do
        puts "Dealer gets another card..."
        card = deck.cards.pop
        dealer.hand << card 
        dealer.hand_total = dealer.total(dealer.hand)
        puts "---"
        puts "#{dealer.name} has been dealt a:"
        puts "#{card.display}"
        puts "#{dealer.name}'s total is #{dealer.hand_total}."
        puts "---"
        if dealer.blackjack?(dealer.hand)
          puts "#{dealer.name} hit blackjack!"
        elsif dealer.bust?(dealer.hand_total)
          puts "#{dealer.name} went bust."
          dealer.hand_total = dealer.total(dealer.hand)
        end
      end
    end
    dealer.hand_total
  end

  # evaluate player totals against dealer total, add/subtract wagers & display
  def evaluate_winners(players, dealer)
    players.each do |p|
      if dealer.bust?(dealer.hand_total) && p.bust?(p.hand_total) != true
        puts "Dealer went bust, #{p.name} beat the dealer!"
        p.chips += p.wager
        puts "#{p.name} now has #{p.chips} chips."
      elsif p.hand_total > dealer.hand_total && p.bust?(p.hand_total) != true
        puts "#{p.name}'s hand better than the dealer!"
        p.chips += p.wager
        puts "#{p.name} now has #{p.chips} chips."
      elsif p.hand_total == dealer.hand_total && p.bust?(p.hand_total) != true
        puts "It's a push betwen #{p.name} and #{dealer.name}"
        puts "#{p.name} now has #{p.chips} chips."
      else
        puts "Bummer, #{p.name}, you lost."
        p.chips -= p.wager
        puts "#{p.name} now has #{p.chips} chips."
      end
    end
  end

  # run hit stay loop for any player
  def hit_stay(p, deck)
    hit_stay = "hit"
    while hit_stay == "hit" && p.blackjack_or_bust?(p.hand_total) != true do
      hit_stay = q_a("#{p.name}, would you like to hit or stay? (hit / stay only)")
      if hit_stay == "hit"
        p.hand << deck.cards.pop
        p.hand_total = p.total(p.hand)
        puts "---"
        puts "#{p.name} has been dealt a:"
        puts "#{p.hand.last.display}"
        puts "#{p.name} now has a total of #{p.hand_total}"
        puts "---"
      else
        puts "#{p.name} chose to stay, has a total of #{p.hand_total}"
      end
      p.hand_total = p.total(p.hand)
    end
  end

  # evaluate whether dealer actually plays round, if any player hit blackjack, no
  def dealer_round?(players)
    players.each do |p|
      if p.blackjack?(p.hand_total)
        false
        break
      else
        true
      end
    end
  end

  def q_a (q)
    puts q
    a = gets.chomp 
  end
 
end

game = Blackjack.new



