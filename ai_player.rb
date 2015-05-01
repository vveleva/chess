require_relative "no_move_error.rb"


class AIPlayer
  attr_reader :name, :color

  def initialize(color)
    @name = "BOT#{rand(10 ** 10..9 * 10 ** 10).to_s(16)}"
    @color = color
  end

  def play_turn(board)
    all_pieces = board.all_pieces_of(color)
    awesome_moves = awesome_move(all_pieces)

    return awesome_moves.first.take(2) unless awesome_moves.empty?
    random_move(all_pieces, board)
  end

  private

    def random_move(all_pieces, board)
      to = nil
      until (to && !board.get_captured?(to, color))
        all_valid_moves = all_pieces.map { |piece| piece.valid_moves }
        if all_valid_moves.flatten.empty?
          raise StalemateError.new "Nowhere to run!"
        end
        from = all_pieces.sample
        to = from.valid_moves.sample
      end

      [from.pos, to]
    end

    def awesome_move(all_pieces)
      awesome_moves = []
      all_pieces.each do |piece|
        moves = piece.valid_moves
        moves.each do |move|
          if piece.check_board_at(move) == :opponent
            awesome_moves << [piece.pos, move, piece.value]
          end
        end
      end

      awesome_moves.sort_by { |_, _, v| v }
    end

end
