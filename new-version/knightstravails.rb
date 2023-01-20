# frozen_string_literal: true

# tree and board
class Tree
  attr_reader(:board, :neighbors)

  def initialize
    @board = {}
    @neighbors = Hash.new { |h, k| h[k] = [] }
    @predecessor = {}
  end

  def create_board
    x_cord = 0
    y_cord = 0
    64.times do |num|
      @board[[x_cord, y_cord]] = num
      x_cord += 1
      y_cord += 1 if x_cord == 8
      x_cord = 0 if x_cord == 8
    end
  end

  def create_neighbors
    moves = [[-1, 2], [-1, -2], [-2, 1], [-2, -1], [1, 2], [1, -2], [2, 1], [2, -1]]
    @board.each do |cord, square|
      moves.each do |move|
        possible_move = [move[0] + cord[0], move[1] + cord[1]]
        @neighbors[square] << @board.values_at(possible_move)[0] if @board.key?(possible_move)
      end
    end
  end

  def bfs(start_square, end_square)
    queue = [start_square]
    visited = []

    until queue.empty?
      current_square = queue.shift
      if current_square == end_square
        print_path(current_square, start_square)
        break
      end
      visited << current_square
      @neighbors[current_square].each do |square|
        unless visited.include?(square)
          queue << square
          @predecessor[square] = current_square
        end
      end
    end
    false
  end

  def print_path(current_square, start_square)
    path = []
    while current_square != start_square
      path.unshift(current_square)
      current_square = @predecessor[current_square]
    end
    path.unshift(start_square)
    p path
  end
end

tree = Tree.new
tree.create_board
tree.create_neighbors

100.times do
  squares = [*0..63]
  ss = squares.sample
  es = squares.sample

  tree.bfs(ss, es)
end
