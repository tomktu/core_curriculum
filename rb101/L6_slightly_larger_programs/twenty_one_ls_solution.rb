SUITS = ['H', 'D', 'S', 'C']
VALUES = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']
WHATEVER_ONE = 21
DEALER_HIT_THRESHOLD = 17

def prompt(msg)
  puts "=> #{msg}"
end

def initialize_deck
  SUITS.product(VALUES).shuffle
end

def total(cards)
  # cards = [['H', '3'], ['S', 'Q'], ... ]
  values = cards.map { |card| card[1] }

  sum = 0
  values.each do |value|
    sum += if value == "A"
             11
           elsif value.to_i == 0 # J, Q, K
             10
           else
             value.to_i
           end
  end

  # correct for Aces
  values.select { |value| value == "A" }.count.times do
    sum -= 10 if sum > WHATEVER_ONE
  end

  sum
end

def busted?(total)
  total > WHATEVER_ONE
end

# :tie, :dealer, :player, :dealer_busted, :player_busted
def detect_result(dealer_total, player_total)
  if player_total > WHATEVER_ONE
    :player_busted
  elsif dealer_total > WHATEVER_ONE
    :dealer_busted
  elsif dealer_total < player_total
    :player
  elsif dealer_total > player_total
    :dealer
  else
    :tie
  end
end

def display_result(dealer_total, player_total)
  result = detect_result(dealer_total, player_total)

  case result
  when :player_busted
    prompt "You busted! Dealer wins!"
  when :dealer_busted
    prompt "Dealer busted! You win!"
  when :player
    prompt "You win!"
  when :dealer
    prompt "Dealer wins!"
  when :tie
    prompt "It's a tie!"
  end
end

def play_again?
  puts "-------------"
  prompt "Do you want to play again? (y or n)"
  answer = gets.chomp
  answer.downcase.start_with?('y')
end

def display_cards_and_total(dealer_cards, dealer_total, player_cards,
                            player_total)
  puts "=============="
  prompt "Dealer has #{dealer_cards}, for a total of: #{dealer_total}"
  prompt "Player has #{player_cards}, for a total of: #{player_total}"
  puts "=============="
end

def clear_screen
  system('clear') || system('cls')
end

def increment_score(score, player)
  score[player] += 1
end

loop do
  clear_screen
  prompt "Welcome to #{WHATEVER_ONE}!"
  score = { dealer: 0, player: 0 }

  loop do
    # clear_screen
    prompt "Current score is: You - #{score[:player]}, Dealer -"\
    " #{score[:dealer]}"

    # initialize vars
    deck = initialize_deck
    player_cards = []
    dealer_cards = []

    # initial deal
    2.times do
      player_cards << deck.pop
      dealer_cards << deck.pop
    end

    player_total = total(player_cards)
    dealer_total = total(dealer_cards)

    prompt "Dealer has #{dealer_cards[0]} and ?"
    prompt "You have: #{player_cards[0]} and #{player_cards[1]}, for a total"\
    " of #{player_total}."

    # player turn
    loop do
      player_turn = nil
      loop do
        prompt "Would you like to (h)it or (s)tay?"
        player_turn = gets.chomp.downcase
        break if ['h', 's'].include?(player_turn)
        prompt "Sorry, must enter 'h' or 's'."
      end

      if player_turn == 'h'
        player_cards << deck.pop
        player_total = total(player_cards)

        prompt "You chose to hit!"
        prompt "Your cards are now: #{player_cards}"
        prompt "Your total is now: #{player_total}"
      end

      break if player_turn == 's' || busted?(player_total)
    end

    if busted?(player_total)
      increment_score(score, :dealer)
      display_cards_and_total(dealer_cards, dealer_total, player_cards,
                              player_total)
      display_result(dealer_total, player_total)

      sleep(5)
      clear_screen
      next
    else
      prompt "You stayed at #{player_total}"
    end

    # dealer turn
    prompt "Dealer turn..."

    loop do
      break if dealer_total >= DEALER_HIT_THRESHOLD

      prompt "Dealer hits!"
      dealer_cards << deck.pop
      prompt "Dealer's cards are now: #{dealer_cards}"
      dealer_total = total(dealer_cards)
    end

    if busted?(dealer_total)
      prompt "Dealer total is now: #{dealer_total}"
      increment_score(score, :player)
      display_cards_and_total(dealer_cards, dealer_total, player_cards,
                              player_total)
      display_result(dealer_total, player_total)

      sleep(5)
      clear_screen
      next
    else
      prompt "Dealer stays at #{dealer_total}"
    end

    # both player and dealer stays - compare cards!
    display_cards_and_total(dealer_cards, dealer_total, player_cards,
                            player_total)
    display_result(dealer_total, player_total)

    winner = detect_result(dealer_total, player_total)

    case winner
    when :player
      increment_score(score, :player)
    when :dealer
      increment_score(score, :dealer)
    end

    sleep(5)
    break if score[:dealer] == 5 || score[:player] == 5
    clear_screen
  end

  if score[:player] == 5
    prompt "Congrats, you are the ultimate winner!"
  else
    prompt "Dealer is the first to 5 wins. Better luck next time."
  end

  break unless play_again?
end

prompt "Thank you for playing Twenty-One! Good bye!"
