require_relative "no_move_error.rb"


class HumanPlayer
  LETTERS_TO_NUM = ("a".."h").to_a

  attr_reader :name, :color

  def initialize(name, color)
    @name = name
    @color = color
  end

  def play_turn(board)
    puts "Please enter your move."
    move = gets.chomp

    raise NoMoveError.new("That isn't a move") unless valid_input?(move)

    arr = move.split(",").map! { |s| s.strip.split("") }
    arr.map { |y, x| [x.to_i - 1, LETTERS_TO_NUM.index(y)] }
  end

  def valid_input?(str)
    chrs = str.strip.split("")
    return false if chrs.length != 6
    return false if chrs[2] != ","
    return false if !LETTERS_TO_NUM.any? { |l| [chrs[0], chrs[4]].include?(l) }
    return false if chrs[1] == "0" || chrs[5] == "0"
    return false if chrs[1].to_i > 8 || chrs[5].to_i > 8

    true
  end
end
