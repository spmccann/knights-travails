# frozen_string_literal: true

require_relative 'knight_moves'
require_relative 'tree'

count = 0
keep_playing = true
while keep_playing == true
  puts '-------------------------'
  puts 'KNIGHTS TRAVAILS'
  puts "Enter 'test' to run 25 random knight coordinate positions"
  puts "Enter 'y' to input your own start/end coordianates:"
  puts 'Any other input to exit'
  answer = gets.downcase.chomp
  case answer
  when 'test'
    while count <= 25
      ran = Random.new
      start = [ran.rand(0..7), ran.rand(0..7)]
      target = [ran.rand(0..7), ran.rand(0..7)]
      knight = KnightMoves.new(start, target)
      knight.positions
      knight.build_tree
      knight.reach_target
      knight.show_path
      puts "-------------------------\n"
      count += 1
    end
    count = 0
  when 'y'
    puts 'Please enter a starting x, y (0-7):'
    starting = gets.chomp.split(',').map(&:to_i)
    puts 'Please enter an ending x, y (0-7):'
    ending = gets.chomp.split(',').map(&:to_i)
    knight = KnightMoves.new(starting, ending)
    knight.positions
    if knight.valid_move(starting) && knight.valid_move(ending)
      knight.build_tree
      knight.reach_target
      knight.show_path
      puts "-------------------------\n"
    else
      puts 'Invalid chess board coordninates. Please try again (0-7)'
    end
  else
    puts 'Later!'
    keep_playing = false
  end
end
