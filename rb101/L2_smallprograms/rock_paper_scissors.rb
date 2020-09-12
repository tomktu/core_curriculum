require 'yaml'

MESSAGES = YAML.load_file('rock_paper_scissors.yml')
VALID_CHOICES = ['rock', 'paper', 'scissors', 'lizard', 'spock']
MAP_OF_WINNING_MOVES = { 'rock' => ['scissors', 'lizard'],
                         'paper' => ['rock', 'spock'],
                         'scissors' => ['paper', 'lizard'],
                         'lizard' => ['paper', 'spock'],
                         'spock' => ['scissors', 'rock'] }

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
    prompt("Choose one: #{VALID_CHOICES.join(', ')}")
    choice = gets.chomp

    if VALID_CHOICES.include?(choice)
      return choice
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

clear_screen
prompt(MESSAGES['welcome'])

loop do
  user_choice = retrieve_user_choice
  computer_choice = VALID_CHOICES.sample

  prompt("You chose: #{user_choice}; Computer chose: #{computer_choice}")

  display_results(user_choice, computer_choice)

  break unless play_again?
end

prompt(MESSAGES['goodbye'])
