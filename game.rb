require_relative 'board.rb'
require_relative 'no_move_error.rb'
require_relative 'human_player.rb'
require_relative 'ai_player.rb'
require_relative 'stalemate_error.rb'


class Game
  attr_reader :board, :white_player, :black_player

  def initialize(white, black)
    @board = Board.new
    @white_player = white
    @black_player = black
  end

  def play
    player = white_player
    turns = 0

    until board.checkmate?(player.color)
      begin
        puts "#{player.color}'s turn."
        board.render_board
        sleep(0.05)
        begin
          start, end_pos = player.play_turn(board)
        rescue StalemateError => check_error
          p check_error.message
          puts "Game over! Stalemate."
          return
        end
        board.move(start, end_pos, player.color)
      rescue NoMoveError => e
        p e.message
        retry
      end

      player = flip_turns(player)
      turns += 1

      if turns % 25 == 0
        if board.grid.flatten.compact == board.pieces_number
          puts "It's a draw!"
          return
        else
          board.pieces_number = board.grid.flatten.compact
        end
      end
    end

    board.render_board
  end

  private

    def flip_turns(player)
      player == white_player ? black_player : white_player
    end

end
