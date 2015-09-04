require 'colorize'

@player1_lives = 0
@player2_lives = 0
@player1_name = ""
@player2_name = ""
@player1_wins = 0
@player2_wins = 0
@replay_wanted = 'yes'

# Main method that starts game
def main
  ask_for_players_names
  while @replay_wanted == 'yes'
    run_game
  end
end

# Runs a set of turns until one of the player loses all lives
def run_game
  @player1_lives = 3
  @player2_lives = 3

  while @player1_lives > 0 && @player2_lives > 0
    player_turn(1)
    break if @player1_lives == 0
    player_turn(2)
  end
end

# Asks for player's names and saves them in the instance variables
def ask_for_players_names
  print "Player 1's name is: "
  @player1_name = gets.chomp
  print"Player 2's name is: "
  @player2_name = gets.chomp
end

# Takes in 2 numbers, player's number, and an operation, and returns the generated question
def generate_question(first_no, second_no, player, operation)
  case operation
  when 'add'
    "\n#{player == 1 ? @player1_name : @player2_name}'s turn: What does #{first_no} plus #{second_no} equal?"
  when 'subtract'
    "\n#{player == 1 ? @player1_name : @player2_name}'s turn: What does #{first_no} minus #{second_no} equal?"
  when 'multiply'
    "\n#{player == 1 ? @player1_name : @player2_name}'s turn: What does #{first_no} times #{second_no} equal?"
  end
end

# Generates random operation and returns a string ('add', 'subtract', 'multiply')
def generate_random_operation
  r = rand(1..3)
  case r
  when 1
    'add'
  when 2
    'subtract'
  when 3
    'multiply'
  end
end

# Generates random number smaller than 20
def generate_random_num
  rand(1..20)
end

# Adds 2 numbers and returns result
def add(a, b)
  a + b
end

# Subtracts 2 numbers and returns result
def subtract(a, b)
  a - b
end

# Multiplies 2 numbers and returns result
def multiply(a, b)
  a * b
end

# Prompts player for answer and returns its output
def prompt_player_for_answer
  print 'Your answer:'
  user_input = gets.chomp.to_i
end

# Takes in the player input and returns true if answer is correct or false if incorrect
def correct_answer?(a, b, player_input, operation)
  case operation
  when 'add'
    result = add(a,b)
  when 'subtract'
    result = subtract(a,b)
  when 'multiply'
    result = multiply(a,b)
  end
  player_input == result
end

# Prompts user for option to play again; returns goodbye messages if option is no or unrecognized string; returns nil if option is yes
def prompt_for_replay
  puts 'Want to play again? (yes/no)'
  @replay_wanted = gets.chomp
  if @replay_wanted == 'yes'
    return nil
  elsif @replay_wanted == 'no'
    return  'Bye bye!'
  else
    @replay_wanted = 'no'
    return 'Didn\'t get that. So bye bye!'
  end
end

# Returns player's name based on player's number (1 or 2)
def player_name(player)
  player == 1 ? @player1_name : @player2_name
end

# Returns player's lives based on player's number (1 or 2)
def player_lives(player)
  player == 1 ? @player1_lives : @player2_lives
end

# Returns other player's name based on player's number (1 or 2)
def other_player_name(player)
  player == 1 ? @player2_name : @player1_name
end

# Prints  number of lives left after each answer (or who won the game if after a final turn)
def print_current_game_status(no_of_lives, player)
  if no_of_lives == 0
    puts end_of_game(player)
    player ==1 ? @player2_wins += 1 : @player1_wins +=1
    puts current_score
    puts prompt_for_replay
  else
    puts player_lives_status(player, no_of_lives)
  end
end

# Returns message announcing end of game and winner; takes the losing player's number
def end_of_game (player)
  "#{player_name(player)} is out of lives! #{other_player_name(player)} won!"
end

# Returns message with current score
def current_score
  "Current score: #{@player1_name}: #{@player1_wins} and #{@player2_name}: #{@player2_wins}."
end

# Takes player's number and lives and returns message with player's name and status of lives
def player_lives_status(player, no_of_lives)
  "#{player_name(player)} has #{no_of_lives} lives left.\n"
end

# Prints green colored message acknowledging correct answer
def answer_is_correct
  'Correct! :-) '.colorize(:green)
end

# Prints red colored message acknowledging incorrect answer
def answer_is_incorrect
  'Incorrect! :-( '.colorize(:red)
end

# Decreases a player's no. of lives based on player's number (1 or 2)
def decrease_no_of_lives(player)
  player == 1 ? @player1_lives = @player1_lives -1 : @player2_lives = @player2_lives -1
end

# Runs a player's turn
# Starts with generating the 2 random numbers and a random operation, then gets player's answer
# Verifies answer, updates number of lives, and prints game status
def player_turn(player)
  first_no = generate_random_num
  second_no = generate_random_num
  operation = generate_random_operation
  puts generate_question(first_no, second_no, player, operation)
  player_input = prompt_player_for_answer
  if correct_answer?(first_no, second_no, player_input,operation)
    print answer_is_correct
  else
    print answer_is_incorrect
    decrease_no_of_lives(player)
  end
  print_current_game_status(player_lives(player), player)
end

main
