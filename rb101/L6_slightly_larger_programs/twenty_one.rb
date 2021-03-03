require 'io/console'
require 'pry'
#-----------------------------------------------------------------------------
# CONSTANTS
#-----------------------------------------------------------------------------
WHATEVER_ONE = 21
DEALER_HIT_THRESHOLD = 17
WINNING_SCORE = 5

#-----------------------------------------------------------------------------
# METHODS
#-----------------------------------------------------------------------------
def prompt(msg, count=1)
  count.times { puts "=> #{msg}" }
end

# rubocop: disable Style/SymbolProc
def initialize_deck
  suits = ['♤', '♡', '♢', '♧']
  cards = ['Ace', 2, 3, 4, 5, 6, 7, 8, 9, 10, 'Jack', 'Queen', 'King']

  deck = cards.product(suits).map do |card|
    card.join
  end

  deck.shuffle
end
# rubocop: enable Style/SymbolProc

def deal_cards(deck, dealer_deck, player_deck)
  count = 0
  while count < 2
    dealer_deck << deck.pop
    player_deck << deck.pop
    count += 1
  end
end

def display_table(score, dealer_deck, player_deck, show_dealer_hand=false)
  prompt("The current score is: You - #{score[:player]}, Dealer -"\
  " #{score[:dealer]}")
  prompt("Dealer has: #{join_and(show_dealer_hand, dealer_deck)}")
  prompt("You have: #{join_and(true, player_deck)}")
end

def join_and(show_all, players_deck, sep=' , ', word='and')
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
  sum_cards > WHATEVER_ONE
end

def get_card_values(persons_deck)
  persons_deck.map do |card|
    if %w(A J Q K).include?(card[0])
      card[0, card.length - 1]
    else
      card[0, card.length - 1].to_i
    end
  end
end

def calculate_sum(persons_deck)
  card_values = get_card_values(persons_deck)
  aces, other_cards = card_values.partition { |card| card == 'Ace' }

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

def get_choice
  loop do
    prompt("(H)it or (S)tay?")
    choice = gets.chomp.downcase
    return choice if %w(h s).include?(choice)
    prompt("Invalid entry, please try again.")
  end
end

def determine_winner(dealer_total, player_total)
  differential = player_total - dealer_total

  if busted?(player_total)
    'player_busted'
  elsif busted?(dealer_total)
    'dealer_busted'
  elsif differential == 0
    'tie'
  elsif differential > 0
    'player'
  else
    'dealer'
  end
end

# rubocop: disable Metrics/MethodLength
def display_result(dealer_total, player_total)
  winner = determine_winner(dealer_total, player_total)

  puts "=============="
  case winner
  when 'player_busted'
    prompt("Busted, you lose. You have #{player_total} and dealer has"\
    " #{dealer_total}.")
  when 'dealer_busted'
    prompt("Dealer busted, you win! You have #{player_total} and dealer has"\
    " #{dealer_total}.")
  when 'tie'
    prompt("It's a tie. You have #{player_total} and dealer has"\
    " #{dealer_total}.")
  when 'player'
    prompt("You win! You have #{player_total} and dealer has"\
    " #{dealer_total}.")
  else
    prompt("You lost. You have #{player_total} and dealer has"\
    " #{dealer_total}.")
  end
  puts "=============="
end
# rubocop: enable Metrics/MethodLength

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

def increment_score(score, player)
  score[player] += 1
end

def continue_game
  prompt("Press any key to continue.")
  STDIN.getch
end
#-----------------------------------------------------------------------------
# PROGRAM
#-----------------------------------------------------------------------------

loop do
  clear_screen
  prompt("Welcome to #{WHATEVER_ONE}!")
  prompt("The total hand value needed to win is #{WHATEVER_ONE}.")
  prompt("Dealer will hit until its total is at least #{DEALER_HIT_THRESHOLD}.")
  prompt("First person to #{WINNING_SCORE} wins is the grand winner!")
  prompt("-------------------------------------------")
  score = { dealer: 0, player: 0 }

  loop do
    deck = initialize_deck
    dealer = []
    player = []

    deal_cards(deck, dealer, player)
    display_table(score, dealer, player)

    dealer_total = calculate_sum(dealer)
    player_total = calculate_sum(player)

    loop do
      choice = get_choice

      if choice == 'h'
        clear_screen
        hit(deck, player)
        display_table(score, dealer, player)
        player_total = calculate_sum(player)
      end

      break if choice == 's' || busted?(player_total)
    end

    if busted?(player_total)
      clear_screen
      increment_score(score, :dealer)
      display_table(score, dealer, player, true)
      display_result(dealer_total, player_total)

      break if score[:player] == 5 || score[:dealer] == 5
      continue_game
      clear_screen
      next
    else
      prompt("You chose to stay.")
      sleep(3)
    end

    counter = 0
    loop do
      break if dealer_total >= DEALER_HIT_THRESHOLD
      counter += 1
      clear_screen
      hit(deck, dealer)
      display_table(score, dealer, player, true)
      prompt("Dealer hits.", counter)
      dealer_total = calculate_sum(dealer)
      sleep(3)
    end

    if busted?(dealer_total)
      increment_score(score, :player)
    else
      prompt("Dealer chose to stay.")
      sleep(3)
    end

    winner = determine_winner(dealer_total, player_total)
    case winner
    when 'player'
      increment_score(score, :player)
    when 'dealer'
      increment_score(score, :dealer)
    end

    clear_screen
    display_table(score, dealer, player, true)
    display_result(dealer_total, player_total)

    break if score[:player] == 5 || score[:dealer] == 5
    continue_game
    clear_screen
  end

  if score[:player] == 5
    prompt("Congrats, you are the ultimate winner!")
  else
    prompt("Dealer is the first to 5 wins. Better luck next time.")
  end

  break unless play_again?
end

prompt("Thanks for playing. Goodbye!")
