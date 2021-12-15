require 'set'
require 'forwardable'

class CostQueue
  def initialize(initial)
    @sorted = initial
  end

  attr_reader :sorted
  extend ::Forwardable
  def_delegators :@sorted, :include?, :empty?

  def <<(tuple)
    if empty?
      sorted << tuple
    else
      insert(tuple)
    end

    self
  end

  def min
    sorted.shift
  end

  protected

  def insert(tuple)
    insert_at = sorted.bsearch_index { |other| tuple.last <= other.last }

    if insert_at.nil?
      sorted << tuple
    else
      sorted.insert(insert_at, tuple)
    end
  end
end

def min_risk(board)
  max_x = board[0].count - 1
  max_y = board.count - 1

  seen = Set.new([0, 0])
  queue = CostQueue.new([[0] * 3])

  while (y, x, cost = queue.min)
    return cost if x == max_x && y == max_y

    [
      [y - 1, x],
      [y + 1, x],
      [y, x - 1],
      [y, x + 1]
    ]
      .reject { |target| target.min < 0 || target.first > max_y || target.last > max_x || seen.include?(target) }
      .each do |t_y, t_x|
      t_cost = board[t_y][t_x] + cost
      queue << [t_y, t_x, t_cost]
      seen << [t_y, t_x]
    end
  end
end

def expand(source)
  y_len = source.length

  expanded = []
  5.times do |y|
    expanded_line = [].fill([], 0...y_len)
    5.times do |x|
      mapped_pos = x + y - 1
      source.each_with_index do |line, row|
        expanded_line[row] += line.map { |val| (val + mapped_pos) % 9 + 1 }
      end
    end
    expanded += expanded_line
  end

  expanded
end

puts File
       .read('input')
       .each_line(chomp: true)
       .map { |l| l.split('').map(&:to_i) }
       .then { |board| expand(board) }
       .then { |expanded| min_risk(expanded) }
