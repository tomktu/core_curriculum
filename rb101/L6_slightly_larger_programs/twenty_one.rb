require 'pry'

#-----------------------------------------------------------------------------
# METHODS
#-----------------------------------------------------------------------------
def prompt(msg, count=1)
  count.times { puts "=> #{msg}" }
end

def initialize_deck
  cards = ['Ace', 2, 3, 4, 5, 6, 7, 8, 9, 10, 'Jack', 'Queen', 'King']
  deck = []

  cards.each do |card|
    deck.concat([card] * 4)
  end

  deck.shuffle
end

def deal_cards(deck, dealer_deck, player_deck)
  count = 0
  while count < 2
    dealer_deck << deck.pop
    player_deck << deck.pop
    count += 1
  end
end

def display_table(dealer_deck, player_deck)
  clear_screen
  prompt("Dealer has: #{join_and(false, dealer_deck)}")
  prompt("You have: #{join_and(true, player_deck)}")
end

def show_cards(dealer_deck, player_deck)
  clear_screen
  prompt("Dealer has: #{join_and(true, dealer_deck)}")
  prompt("You have: #{join_and(true, player_deck)}")
end

def join_and(show_all, players_deck, sep=', ', word='and')
  if show_all
    if players_deck.size == 2
      return players_deck.join(" #{word} ")
    else
      cards = players_deck.clone
      cards[-1] = "#{word} #{cards[-1]}"
      return cards.join(sep)
    end
  end

  if players_deck.size == 2
    "#{players_deck[0]} and unknown card"
  else
    "#{players_deck[0]} and #{players_deck.size - 1} unknown cards"
  end
end

def hit(deck, persons_deck)
  persons_deck << deck.pop
end

def busted?(sum_cards)
  sum_cards > 21
end

def calculate_sum(persons_deck)
  aces, other_cards = persons_deck.partition { |card| card == 'Ace' }

  sum_other_cards = other_cards.map do |card|
    %w(Jack King Queen).include?(card) ? 10 : card
  end.sum

  if aces.size == 0
    sum_other_cards
  elsif aces.size >= (12 - sum_other_cards)
    sum_other_cards + aces.size
  else
    sum_other_cards + 10 + aces.size
  end
end

def hit?
  loop do
    prompt("Hit or Stay?")
    choice = gets.chomp.downcase
    return choice if %w(hit stay).include?(choice)
    prompt("Invalid entry, please try again.")
  end
end

def determine_winner(dealer_total, player_total)
  differential = player_total - dealer_total

  if differential == 0
    'tie'
  elsif differential > 0
    'player'
  else
    'dealer'
  end
end

def play_again?
  choice = ''
  loop do
    prompt "Play again? (y or n)"
    choice = gets.chomp.downcase
    break if %w(y n).include?(choice)
    prompt "That was an invalid input. Please try again."
  end
  choice == 'y'
end

def clear_screen
  system('clear') || system('cls')
end
#-----------------------------------------------------------------------------
# PROGRAM
#-----------------------------------------------------------------------------

loop do
  deck = initialize_deck
  dealer = []
  player = []

  deal_cards(deck, dealer, player)
  display_table(dealer, player)

  dealer_total = calculate_sum(dealer)
  player_total = calculate_sum(player)

  loop do
    choice = hit?

    if choice == 'hit'
      hit(deck, player)
      display_table(dealer, player)
      player_total = calculate_sum(player)
    end

    break if choice == 'stay' || busted?(player_total)
  end

  if busted?(player_total)
    show_cards(dealer, player)
    prompt("Busted. You lose.")
    next if play_again?
    break
  else
    prompt("You chose to stay.")
    sleep(2)
  end

  counter = 0
  loop do
    break if dealer_total >= 17
    counter += 1
    hit(deck, dealer)
    display_table(dealer, player)
    prompt("Dealer hits.", counter)
    dealer_total = calculate_sum(dealer)
    sleep(2)
  end

  if busted?(dealer_total)
    show_cards(dealer, player)
    prompt("Dealer busted. You win!")
  else
    prompt("Dealer chose to stay.")
    sleep(2)

    show_cards(dealer, player)
    winner = determine_winner(dealer_total, player_total)

    if winner == 'tie'
      prompt("It's a tie. You have #{player_total} and dealer has"\
      " #{dealer_total}.")
    elsif winner == 'player'
      prompt("You win! You have #{player_total} and dealer has"\
      " #{dealer_total}.")
    else
      prompt("You lost. You have #{player_total} and dealer has"\
      " #{dealer_total}.")
    end
  end

  break unless play_again?
end

prompt("Thanks for playing. Goodbye!")
