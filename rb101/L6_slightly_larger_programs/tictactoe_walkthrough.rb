require 'pry'

=begin
-----------------------------------------------------------------------------
CONSTANTS
-----------------------------------------------------------------------------
=end

FIRST_MOVER = 'choose'
INITIAL_MARKER = ' '
PLAYER_MARKER = 'X'
COMPUTER_MARKER = 'O'
WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] +
                [[1, 4, 7], [2, 5, 8], [3, 6, 9]] +
                [[1, 5, 9], [3, 5, 7]]

=begin
-----------------------------------------------------------------------------
METHODS
-----------------------------------------------------------------------------
=end

def prompt(msg)
  puts "=> #{msg}"
end

# rubocop: disable Metrics/AbcSize, Metrics/MethodLength
def display_board(brd, score)
  system 'clear'
  puts "You're a #{PLAYER_MARKER}. Computer is #{COMPUTER_MARKER}."
  puts "The current score is - Player:#{score['Player']},"\
  " Computer:#{score['Computer']}"
  puts ""
  puts "     |     |"
  puts "  #{brd[1]}  |  #{brd[2]}  |  #{brd[3]}"
  puts "     |     |"
  puts "-----+-----+-----"
  puts "     |     |"
  puts "  #{brd[4]}  |  #{brd[5]}  |  #{brd[6]}"
  puts "     |     |"
  puts "-----+-----+-----"
  puts "     |     |"
  puts "  #{brd[7]}  |  #{brd[8]}  |  #{brd[9]}"
  puts "     |     |"
  puts ""
end
# rubocop: enable Metrics/AbcSize, Metrics/MethodLength

def initialize_board
  new_board = {}
  (1..9).each { |num| new_board[num] = INITIAL_MARKER }
  new_board
end

def empty_squares(brd)
  brd.keys.select { |num| brd[num] == INITIAL_MARKER }
end

def player_places_piece!(brd)
  square = ''
  loop do
    prompt "Choose a square (#{joinor(empty_squares(brd))}):"
    square = gets.chomp.to_i

    break if empty_squares(brd).include?(square)
    prompt "Sorry, that's not a valid choice."
  end

  brd[square] = PLAYER_MARKER
end

def joinor(arr, sep=', ', word='or')
  if arr.empty?
    ''
  elsif arr.size == 1
    arr.join
  elsif arr.size == 2
    arr.join(" #{word} ")
  else
    arr[-1] = "#{word} #{arr.last}"
    arr.join(sep)
  end
end

def computer_places_piece!(brd)
  if win_opportunity?(brd)
    brd[find_winning_move(brd)] = COMPUTER_MARKER
  elsif immediate_threat?(brd)
    brd[find_threat(brd)] = COMPUTER_MARKER
  elsif brd[5] == INITIAL_MARKER
    brd[5] = COMPUTER_MARKER
  else
    square = empty_squares(brd).sample
    brd[square] = COMPUTER_MARKER
  end
end

def immediate_threat?(brd)
  !!find_threat(brd)
end

def find_threat(brd)
  WINNING_LINES.each do |line|
    if brd.values_at(*line).count(PLAYER_MARKER) == 2 &&
       brd.values_at(*line).count(INITIAL_MARKER) == 1
      line.each { |key| return key if brd[key] == INITIAL_MARKER }
    end
  end

  nil
end

def win_opportunity?(brd)
  !!find_winning_move(brd)
end

def find_winning_move(brd)
  WINNING_LINES.each do |line|
    if brd.values_at(*line).count(COMPUTER_MARKER) == 2 &&
       brd.values_at(*line).count(INITIAL_MARKER) == 1
      line.each { |key| return key if brd[key] == INITIAL_MARKER }
    end
  end

  nil
end

def board_full?(brd)
  empty_squares(brd).empty?
end

def someone_won?(brd)
  !!detect_winner(brd)
end

def detect_winner(brd)
  WINNING_LINES.each do |line|
    # if brd[line[0]] == PLAYER_MARKER &&
    #    brd[line[1]] == PLAYER_MARKER &&
    #    brd[line[2]] == PLAYER_MARKER
    #   return 'Player'
    # elsif brd[line[0]] == COMPUTER_MARKER &&
    #       brd[line[1]] == COMPUTER_MARKER &&
    #       brd[line[2]] == COMPUTER_MARKER
    #   return 'Computer'
    # end
    if brd.values_at(*line).count(PLAYER_MARKER) == 3
      return 'Player'
    elsif brd.values_at(*line).count(COMPUTER_MARKER) == 3
      return 'Computer'
    end
  end

  nil
end

def increment_score(winner, score)
  score[winner] += 1
end

def select_first_mover
  loop do
    prompt "Who goes first? (Computer, Player)"
    choice = gets.chomp.downcase
    return choice if %w(computer player).include?(choice)
    prompt "Invalid entry, try again."
  end
end

def place_piece!(board, player)
  if player == 'player'
    player_places_piece!(board)
  elsif player == 'computer'
    computer_places_piece!(board)
  end
end

def alternate_player(current_player)
  case current_player
  when 'player'
    'computer'
  when 'computer'
    'player'
  end
end

=begin
-----------------------------------------------------------------------------
PROGRAM
-----------------------------------------------------------------------------
=end

loop do
  first_mover = FIRST_MOVER == 'choose' ? select_first_mover : FIRST_MOVER

  score = { 'Player' => 0,
            'Computer' => 0 }

  loop do
    board = initialize_board
    current_player = first_mover

    loop do
      display_board(board, score)
      place_piece!(board, current_player)
      current_player = alternate_player(current_player)
      break if someone_won?(board) || board_full?(board)
    end

    display_board(board, score)

    if someone_won?(board)
      increment_score(detect_winner(board), score)
      prompt "#{detect_winner(board)} won!"
    else
      prompt "It's a tie!"
    end

    break if score['Player'] == 5 || score['Computer'] == 5

    prompt "Next game starting in 3 seconds."
    sleep(3)
  end

  if score['Player'] == 5
    prompt "You won 5 games and are the ultimate winner!"
  else
    prompt "Sorry, the computer reached 5 wins before you."
  end

  prompt "Play again? (y or n)"
  answer = gets.chomp
  break unless answer.downcase.start_with?('y')
end

prompt "Thanks for play Tic Tac Toe! Good bye!"
