# super class - both dealer & players share name / scores / status method commenting out for now, not sure this is necessary
# class Gambler
#   attr_accessor :name, :score, :status

#   def initialize n, s
#     @name = n
#     @score = s
#   end

#   # takes current score as input - returns blackjack/bust as string or current score if neither, kinda sloppy maybe rethink this
#   def status s
#     status = s
#     if s == 21
#       status = 'blackjack'
#     elsif s > 21
#       status = 'bust'
#     end
#     status
#   end
# end

class Player 
  attr_accessor :name, :hand, :score
  
  def initialize n
    @name = n
    @hand = []
    @score = 0
  end

  # pass in player, return updated hand value
  # def round p
  #   hit = true
  #   while hit
  #     puts "You have #{p.@hand}, your current score is "
  #   end
  # end
end

class Dealer < Player
  attr_accessor :deck, :hand

  # speaks, takes what to speak string command as input
  def speak s
    case s 
      when 'num_players'
        words = 'How many players will there be?'
      when 'welcome'
        words = 'Welcome to the casino!!!'
      when 'name'
        words = 'What is your name?'
      when 'play'
        words = 'Shoud we play another game?'
      when 'hit'
        words = 'Do you want to hit or not?'
    end
    words
  end
end



class Deck
  attr_accessor :cards, :num_decks
  # set up suits & values as constants, they should never change
  SUITS = ['S', 'C', 'D', 'H']
  VALUES = ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K']

  # takes number of decks as input
  def initialize n
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
  
  # returns shuffled array of cards, no matter how many cards there are
  def shuffle 
    @cards.shuffle
  end

  def first_deal
    2.times do
      @players.each do |x|
        @players[x].hand <<  @deck.pop
        puts "#{@players[x].hand}"
      end
      @dealer.hand << @deck.pop
      puts "#{@dealer.hand}"
    end
  end

  #takes any number cards to deal as input, returns the dealt cards
  def deal n
    @dealt_cards = []
    n.times {@dealt_cards << @cards.pop}
    @dealt_cards
  end
end

class Card 
  attr_accessor :suit, :value

  def initialize s, v
    @suit = s
    @value = v
  end

  def display_card
    "#{suit}, #{value}"
  end
end

# this is the "engine" that runs blackjack game
class Blackjack
  attr_accessor :dealer, :player, :deck

  def initialize 
    @dealer = Dealer.new('Dealer')
    @player = []
    # can change how many decks get shuffled here, 4 vegas style
    @deck = Deck.new(4)
    run
  end

  # after initialization, this runs one full game, use recursion to y/n run again, idea of popping off players if they don't want to play
  # output here, who won? 
  def run
    @players = store_players(@players)
    first_deal(@deck.cards)
  end

  def store_players arr 
    puts @dealer.speak('num_players')
    num_players = gets.chomp.to_i
    player_id = 1
    num_players.times do
      puts "Player #{player_id}, " + @dealer.speak('name')
      name = gets.chomp
      # create player and push to players array
      arr << Player.new(name)
      player_id += 1
    end
    puts arr[0].name
    puts arr[1].name
    puts arr[2].name
    arr
  end


  # players take turns
  def player_rounds
    @players.each do |p| 
     p.round
    end
  end
end

game = Blackjack.new





