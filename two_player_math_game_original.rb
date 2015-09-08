require 'colorize'

class InvalidGuessError < StandardError; end
class InvalidPlayerNameError < StandardError; end

class Player

  attr_accessor :name, :lives
  attr_reader :points

  def initialize(name)
    @name = name
    @lives = 3
    @points = 0
  end

  # Simulates a player's turn, and returns the number of lives left after the turn is over
  def turn
    question = MathQuestion.new
    print "#{@name}'s turn:' #{question.print} \nYour answer: "
    player_answer = gets.chomp.to_i
    if player_answer == 0
      begin
        raise InvalidGuessError
      rescue InvalidGuessError
        puts "Invalid input, please try again!"
        print 'Your answer:'
        user_input = gets.chomp.to_i
      end
    end

    if player_answer == question.result
      puts "#{print_answer(true)} #{@name} has #{@lives} lives left."
      @lives
    else
      lose_a_life
      puts "#{print_answer(false)} #{@name} has #{@lives} lives left."
      @lives
    end
  end

  # Takes in a boolean and prints green/correct message if true and red/incorrect message if false
  def print_answer(bool)
    if bool == true
      'Correct! :-) '.colorize(:green)
    else
      'Incorrect! :-( '.colorize(:red)
    end
  end

  # Decreases number of lives by 1 and returns the result
  def lose_a_life
    @lives -= 1
  end

  # Increases player's number of points by one and returns the result
  def gain_a_point
    @points += 1
  end

  # Resets number of lives to 3
  def reset_lives
    @lives = 3
  end

end


class MathQuestion

  attr_reader :first_no, :second_no, :operation

  def initialize
    @first_no = rand(1..20)
    @second_no = rand(1..20)
    @operation = ['plus', 'minus','times'].sample
  end

  # Generate string with math question
  def print
    "What does #{@first_no} #{@operation} #{@second_no} equal?"
  end

  # Returns correct result of an operation
  def result
    case @operation
    when 'plus'
      @first_no + @second_no
    when 'minus'
      @first_no - @second_no
    when 'times'
      @first_no * @second_no
    end
  end

end

class Game

  def initialize
    @replay_wanted = ''
  end

  # Gets player's names and creates Player instances
  def get_players_names
    print "Player 1's name is: "
    @player1 = Player.new(gets.chomp)
    validate_player_name(1, @player1.name)
    print"Player 2's name is: "
    @player2 = Player.new(gets.chomp)
    validate_player_name(2, @player2.name)
  end

  # Checks that player's names aren't empty
  def validate_player_name(player, input)
    if input.empty?
      begin
        raise InvalidPlayerNameError
      rescue InvalidPlayerNameError
        puts "You didn't type your name, please try again!"
        print "Player #{player}'s name:'"
        @player1_name = gets.chomp
      end
    end
  end

  # Runs a round of the game; stops when a player loses all 3 lives; updates score for winner; prints score; resets lives for a new possilble round
  def run_a_game_round
    while @player1.lives > 0 && @player2.lives > 0
      @player1.turn
      break if @player1.lives == 0
      @player2.turn
    end
    winner.gain_a_point
    puts show_score
    @player1.reset_lives
    @player2.reset_lives
  end

  # Returns the player who won the round
  def winner
    @player1.lives > @player2.lives ? @player1 : @player2
  end

  # Generates string with result of a game round and current score
  def show_score
    "#{winner.name} won!. Current score: #{@player1.name} #{@player1.points} - #{@player2.name} #{@player2.points}."
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

  # Starts a game; prompts for player names and starts game round while players want replay
  def start_game
    get_players_names
    while @replay_wanted != 'no'
      run_a_game_round
      puts prompt_for_replay
    end
  end

end

Game.new.start_game
