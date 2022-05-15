# frozen_string_literal: true

# knight piece
class Tree
  attr_accessor :position, :one, :two, :three, :four, :five, :six

  def initialize(position)
    @position = position
    @one = []
    @two = []
    @three = []
    @four = []
    @five = []
    @six = []
  end
end
