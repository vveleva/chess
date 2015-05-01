require_relative 'sliding_piece.rb'


class Rook < SlidingPiece

  attr_accessor :pos
  attr_reader :board, :color, :symbol, :value

  def initialize(board, pos, color)
    super(board, pos, color)
    @symbol = "\u265C"
    @value = 5
  end

  private

    def move_dirs
      ORTHOGONALS
    end
end
