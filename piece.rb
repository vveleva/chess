class Piece
  attr_accessor :pos
  attr_reader :board, :color, :symbol

  def initialize(board, pos, color)
    @board, @pos, @color = board, pos, color
  end

  def valid_moves
    valid_moves = []
    moves.each do |destination|
      new_board = board.dup
      new_board.make_move(pos, destination)
      valid_moves << destination unless new_board.in_check?(color)
    end

    valid_moves
  end

  def inspect
    { pos: pos, color: color }.inspect
  end

  def check_board_at(pos)
    return :nil_tile if board[pos].nil?
    return :opponent if board[pos].color != color

    :ally
  end

  private

    def off_board?(pos)
      pos.min < 0 || pos.max > 7
    end

end
