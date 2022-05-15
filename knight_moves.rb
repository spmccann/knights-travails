# frozen_string_literal: true

# Finding path for knight to target
class KnightMoves
  def initialize(knight, target)
    @knight = knight
    @target = target
    @ranks = [*0..7]
    @files = [*0..7]
    @all_sqs = positions
    @moves = [[-2, -1], [-2, 1], [-1, 2], [-1, -2], [-1, 2], [1, -2], [1, 2], [2, -1], [2, 1]]
    @root = build_tree(knight)
    @path = []
  end

  # creates all 64 postions on a chess board
  def positions
    all_sqs = []
    i = 0
    while i < 8
      all_sqs += @ranks.map { |r| [@files[r], i] }
      i += 1
    end
    all_sqs
  end

  # checks that the position coordinates are valid squares. defaults to knight
  def valid_move(knight = @knight)
    true if @all_sqs.include?(knight)
  end

  # given an array of current coordinates, finds all available squares to move to AND if valid moves.
  def available_moves(knight = @knight)
    all = @moves.map { |m| [m[0] + knight[0], m[1] + knight[1]] }
    all.map { |move| move if valid_move(move) }.compact.uniq
  end

  # index/board number for available_moves between 0-63 given array of coordinates.
  def available_positions(knight = @knight)
    @all_sqs.map { |sq| @all_sqs.index(sq) if available_moves(knight).include?(sq) }.compact
  end

  # get index/board number of a square.
  def square_index(knight = @knight)
    @all_sqs.index(knight) if valid_move(knight)
  end

  # exhaustive tree pathing of moves branching from the starting knight square
  def build_tree(knight = @knight)
    goal = square_index(@target)
    root = Tree.new(square_index(knight))
    root.one << moves = available_positions(knight)
    root.two << moves = moves.flatten.map { |m| available_positions(@all_sqs.at(m)) } unless moves.flatten.include?(goal)
    root.three << moves = moves.flatten.map { |m| available_positions(@all_sqs.at(m)) } unless moves.flatten.include?(goal)
    root.four << moves = moves.flatten.map { |m| available_positions(@all_sqs.at(m)) } unless moves.flatten.include?(goal)
    root.five << moves = moves.flatten.map { |m| available_positions(@all_sqs.at(m)) } unless moves.flatten.include?(goal)
    root.six << moves.flatten.map { |m| available_positions(@all_sqs.at(m)) } unless moves.flatten.include?(goal)
    root
  end

  # checks which depth the target is found in and gets the array index which is the index of the next depth element
  def reach_target
    goal = square_index(@target)
    if @root.two.flatten.include?(goal)
      depth = 1
      node = @root.two[0].map.with_index { |arr, i| i if arr.include?(goal) }.compact
      find_path(depth, node)
    elsif @root.three.flatten.include?(goal)
      depth = 2
      node = @root.three[0].map.with_index { |arr, i| i if arr.include?(goal) }.compact
      find_path(depth, node)
    elsif @root.four.flatten.include?(goal)
      depth = 3
      node = @root.four[0].map.with_index { |arr, i| i if arr.include?(goal) }.compact
      find_path(depth, node)
    elsif @root.five.flatten.include?(goal)
      depth = 4
      node = @root.five[0].map.with_index { |arr, i| i if arr.include?(goal) }.compact
      find_path(depth, node)
    elsif @root.six.flatten.include?(goal)
      depth = 5
      node = @root.six[0].map.with_index { |arr, i| i if arr.include?(goal) }.compact
      find_path(depth, node)
    end
  end

  # work backwards from the target by getting the location of the next coordinates
  def find_path(depth = 0, node = nil)
    case depth
    when 5
      next_node = @root.five.flatten.at(node[0])
      node = @root.five[0].map.with_index { |arr, i| i if arr.include?(next_node) }.compact
      @path << next_node
    when 4
      next_node = @root.four.flatten.at(node[0])
      node = @root.four[0].map.with_index { |arr, i| i if arr.include?(next_node) }.compact
      @path << next_node
    when 3
      next_node = @root.three.flatten.at(node[0])
      node = @root.three[0].map.with_index { |arr, i| i if arr.include?(next_node) }.compact
      @path << next_node
    when 2
      next_node = @root.two.flatten.at(node[0])
      node = @root.two[0].map.with_index { |arr, i| i if arr.include?(next_node) }.compact
      @path << next_node
    when 1
      next_node = @root.one.flatten.at(node[0])
      @path << next_node
    end
    depth -= 1
    find_path(depth, node) if depth.positive?
  end

  # print out the knight's path
  def show_path
    cords = @path.reverse.map { |p| @all_sqs.at(p) }
    cords.push(@target)
    cords.unshift(@knight)
    if @knight == @target
      puts "You're already on that square!"
      puts "#{@knight}\n#{@target}"
    else
      puts "You made it in #{cords.length - 1} moves! Here's your path:\n"
      cords.each { |c| puts c.inspect }
    end
  end
end
