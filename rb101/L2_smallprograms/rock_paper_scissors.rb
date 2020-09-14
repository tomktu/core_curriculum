require 'yaml'

MESSAGES = YAML.load_file('rock_paper_scissors.yml')
MAP_OF_WINNING_MOVES = { 'rock' => ['scissors', 'lizard'],
                         'paper' => ['rock', 'spock'],
                         'scissors' => ['paper', 'lizard'],
                         'lizard' => ['paper', 'spock'],
                         'spock' => ['scissors', 'rock'] }
VALID_CHOICES = MAP_OF_WINNING_MOVES.keys
VALID_CHOICES_SHORTFORM = { 'r' => 'rock',
                            'p' => 'paper',
                            'sc' => 'scissors',
                            'l' => 'lizard',
                            'sp' => 'spock' }

def clear_screen
  system('clear') || system('cls')
end

def win?(first, second)
  MAP_OF_WINNING_MOVES[first].include?(second)
end

def display_results(player, computer)
  if player == computer
    prompt("It's a tie!")
  elsif win?(player, computer)
    prompt("You won!")
  else
    prompt("Computer won!")
  end
end

def prompt(message)
  puts("=> #{message}")
end

def retrieve_user_choice
  loop do
    prompt(MESSAGES['choose_move'])
    choice = gets.chomp.downcase

    if VALID_CHOICES.include?(choice)
      return choice
    elsif VALID_CHOICES_SHORTFORM.keys.include?(choice)
      return VALID_CHOICES_SHORTFORM[choice]
    else
      prompt(MESSAGES['invalid_choice'])
    end
  end
end

def play_again?
  answer = nil
  loop do
    prompt(MESSAGES['again?'])
    answer = gets.chomp.downcase

    break if %w(y n).include?(answer)

    prompt(MESSAGES['invalid_choice'])
  end

  answer == 'y'
end

def display_choices(user_choice, computer_choice)
  prompt("You chose: #{user_choice}; Computer chose: #{computer_choice}")
end

def increment_score(player, computer, score)
  if win?(player, computer)
    score['user'] += 1
  elsif win?(computer, player)
    score['computer'] += 1
  end
end

def display_score(score)
  prompt("The current score is -- User: #{score['user']} Computer:"\
    " #{score['computer']}")
end

def display_initial_game_start
  prompt(MESSAGES['game_start'])
end

def display_grand_winner(score)
  if score['user'] == 5
    prompt(MESSAGES['win_message'])
  else
    prompt(MESSAGES['loss_message'])
  end
end

def display_encouragement
  prompt(MESSAGES['encouragement'])
end

def display_motivation
  prompt(MESSAGES['motivation'])
end

def display_tie_breaker
  prompt(MESSAGES['tie_breaker'])
end

clear_screen
prompt(MESSAGES['welcome'])

loop do
  score = { 'user' => 0, 'computer' => 0 }

  display_score(score)
  display_initial_game_start

  while score['user'] < 5 && score['computer'] < 5
    user_choice = retrieve_user_choice
    computer_choice = VALID_CHOICES.sample

    clear_screen

    display_choices(user_choice, computer_choice)
    display_results(user_choice, computer_choice)

    increment_score(user_choice, computer_choice, score)
    display_score(score)

    display_encouragement if score['computer'] == 4 && score['user'] < 3
    display_motivation if score['user'] == 4 && score['computer'] < 4
    display_tie_breaker if score['computer'] == 4 && score['user'] == 4
  end

  display_grand_winner(score)

  break unless play_again?
end

prompt(MESSAGES['goodbye'])
