require 'yaml'

MESSAGES = YAML.load_file('ttt_attempt.yml')
VALID_CHOICES = ['00', '01', '02',
                 '10', '11', '12',
                 '20', '21', '22']

def clear_screen
  system('clear') || system('cls')
end

def prompt(message)
  puts("=> #{message}")
end

def display_game_start
  promt(MESSAGES['game_start'])
end

def display_board(board)
  result_str = "  0 1 2\n"

  board.each_with_index do |row, index|
    result_str << "#{index} "

    row.each_with_index do |square, index|
      if index == row.length - 1
        result_str << "#{square}\n"
      else
        result_str << "#{square}|"
      end
    end

    result_str << "  _ _ _\n" if index != board.length - 1
  end

  puts result_str
end

def retrieve_user_choice(board)
  loop do
    prompt(MESSAGES['make_move'])
    choice = gets.chomp

    if VALID_CHOICES.include?(choice)
      if square_empty?(board, choice)
        return choice
      else
        prompt(MESSAGES['square_marked'])
      end
    else
      prompt(MESSAGES['invalid_choice'])
    end
  end
end

def generate_computer_choice(board)
  loop do
    choice = VALID_CHOICES.sample

    return choice if square_empty?(board, choice)
  end
end

def square_empty?(board, choice)
  row, column = choice.split('')

  board[row][column] == ' '
end

def mark_move(board, choice, player)
  row, column = choice.split('')

  if player == 'user'
    board[row][column] = 'X'
  elsif player == 'computer'
    board[row][column] = 'O'
  end
end

def display_choices(user_choice, computer_choice)
  prompt("You chose to mark at location #{user_choice}; computer chose to mark at location #{computer_choice}")
end

def rotate_board(board)
  rotated_board = []

  board.each_with_index do |_, c_index|
    rotated_row = []

    board.each_with_index do |_, r_index|
      r_index = -1 - r_index
      rotated_row << board[r_index][c_index]
    end

    rotated_board << rotated_row
  end

  rotated_board
end

def calculate_winner(board)
  user_connect = 'XXX'
  computer_connect = 'OOO'

  board.each do |row|
    if row.join('') == user_connect
      return 'user'
    elsif row.join('') == computer_connect
      return 'computer'
    end
  end

  diagonal = ''
  board.each_with_index do |row, index|
    diagonal << row[index]
  end

  if diagonal == user_connect
    return 'user'
  elsif diagonal == computer_connect
    return 'computer'
  end

  rotated_board = rotate_board(board)

  rotated_board.each do |row|
    if row.join('') == user_connect
      return 'user'
    elsif row.join('') == computer_connect
      return 'computer'
    end
  end

  diagonal = ''
  rotated_board.each_with_index do |row, index|
    diagonal << row[index]
  end

  if diagonal == user_connect
    return 'user'
  elsif diagonal == computer_connect
    return 'computer'
  end

  nil
end

def board_full?(board)
  board.all? do |row|
    row.all? {|square| square != ' '}
  end
end

clear_screen
prompt(MESSAGES['welcome'])

loop do
  winner = nil
  tie = nil
  board = [
            [' ',' ',' '],
            [' ',' ',' '],
            [' ',' ',' ']
          ]

  dispay_game_start
  display_board(board)

  loop do
    user_choice = retrieve_user_choice(board)
    mark_move(board, user_choice, 'user')

    computer_choice = generate_computer_choice(board)
    mark_move(board, computer_choice, 'computer')

    display_choices(user_choice, computer_choice)
    display_board(board)

    winner = calculate_winner(board)
    tie = board_full?(board)

    break if winner || tie
  end



end
