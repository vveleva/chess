require_relative 'rook.rb'
require_relative 'knight.rb'
require_relative 'bishop.rb'
require_relative 'queen.rb'
require_relative 'king.rb'
require_relative 'pawn.rb'
require_relative 'no_move_error.rb'

require 'colorize'


class Board

  attr_accessor :pieces_number
  attr_reader   :grid

  def initialize(empty = false)
    @grid = Array.new(8) { Array.new(8) }
    build_board unless empty
    @pieces_number = 32
  end

  def render_board
    system("clear")
    row_col_color = :blue
    puts ("     " + ("a".."h").to_a.join(" ")).colorize(row_col_color)
    puts ("  \u2554" + "\u2550" * 18 + "\u2557").colorize(row_col_color)

    grid.each_with_index do |row, i|
      row_string = "#{i + 1} \u2551 ".colorize(row_col_color)
      row.each_with_index { |tile, j| row_string += render_row(tile, i, j) }
      puts row_string + " \u2551 #{i + 1}".colorize(row_col_color)
    end

    puts ("  \u255A" + "\u2550" * 18 + "\u255D").colorize(row_col_color)
    puts ("    " + ("a".."h").to_a.join(" ")).colorize(row_col_color)
  end

  def render_row(tile, i, j)
    row_string = ""
    if tile.nil?
      row_string << color_tile("  ", i, j)
    else
      x, y = tile.pos
      if tile.color == :black
        el = color_tile(tile.symbol.black + " ", x, y)
      else
        el = color_tile(tile.symbol.light_white + " ", x, y)
      end
      row_string << el
    end

    row_string
  end

  def color_tile(str, x, y)
    if (x % 2 == 0 && y % 2 == 0) || (x % 2 == 1 && y % 2 == 1)
      str.colorize(background: :light_blue)
    else
      str.colorize(background: :blue)
    end
  end

  def get_captured?(pos, color)
    all_pieces_of(other_color(color)).each do |piece|
      return true if piece.moves.include?(pos)
    end

    false
  end

  def in_check?(color)
    king = find_piece(color, King).first
    all_pieces_of(other_color(color)).each do |piece|
      return true if piece.moves.include?(king.pos)
    end

    false
  end

  def all_pieces_of(color)
    grid.flatten.compact.select { |piece| piece.color == color}
  end

  def move(start, end_pos, color)
    begin
      raise NoMoveError.new "this is nil" if self[start].nil?
      unless self[start].valid_moves.include?(end_pos)
        raise NoMoveError.new "can't go there"
      end
      raise NoMoveError.new "wrong color" if color != self[start].color
      make_move(start, end_pos)
      pawn_to_queen(color)
    end
  end

  def make_move(start, end_pos)
    self[start].pos = end_pos
    self[end_pos]   = self[start]
    self[start]     = nil
  end

  def checkmate?(color)
    return false unless in_check?(color)
    all_pieces_of(color).each do |piece|
      return false unless piece.valid_moves.empty?
    end
    puts "Game over! You win, #{color}!"

    true
  end

  def [](pos)
    x, y = pos
    grid[x][y]
  end

  def []=(pos, value)
    x, y = pos
    grid[x][y] = value
  end

  def dup
    new_board = Board.new(empty = true)
    grid.flatten.compact.each do |piece|
      new_board[piece.pos] = piece.class.new(new_board, piece.pos, piece.color)
    end

    new_board
  end

  def find_piece(color, type)
    all_pieces_of(color).select {|i| i.is_a? type }
  end

  private

    def build_board
      grid[0][0] = Rook.new(self,   [0, 0], :white)
      grid[0][1] = Knight.new(self, [0, 1], :white)
      grid[0][2] = Bishop.new(self, [0, 2], :white)
      grid[0][3] = Queen.new(self,  [0, 3], :white)
      grid[0][4] = King.new(self,   [0, 4], :white)
      grid[0][5] = Bishop.new(self, [0, 5], :white)
      grid[0][6] = Knight.new(self, [0, 6], :white)
      grid[0][7] = Rook.new(self,   [0, 7], :white)

      grid[7][0] = Rook.new(self,   [7, 0], :black)
      grid[7][1] = Knight.new(self, [7, 1], :black)
      grid[7][2] = Bishop.new(self, [7, 2], :black)
      grid[7][3] = Queen.new(self,  [7, 3], :black)
      grid[7][4] = King.new(self,   [7, 4], :black)
      grid[7][5] = Bishop.new(self, [7, 5], :black)
      grid[7][6] = Knight.new(self, [7, 6], :black)
      grid[7][7] = Rook.new(self,   [7, 7], :black)

      grid[1].each_index { |i| grid[1][i] = Pawn.new(self, [1, i], :white) }
      grid[6].each_index { |i| grid[6][i] = Pawn.new(self, [6, i], :black) }
    end

    def other_color(color)
      color == :white ? :black : :white
    end

    def pawn_to_queen(color)
      pawns = find_piece(color, Pawn)
      pawns.each do |pawn|
        if [0, 7].include?(pawn.pos.first)
          self[pawn.pos] = Queen.new(self, pawn.pos, color)
        end
      end
    end

end
