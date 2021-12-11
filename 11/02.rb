require 'set'

INDICES = (0...10).to_a.product((0...10).to_a).to_set

def parse(board)
  {}.tap do |table|
    INDICES.each do |(x,y)|
      table[[x, y]] = board[x][y]
    end
  end
end

def adjacent(x, y)
  [
    [x - 1, y],
    [x + 1, y],
    [x, y - 1],
    [x, y + 1],
    [x - 1, y - 1],
    [x - 1, y + 1],
    [x + 1, y - 1],
    [x + 1, y + 1],
  ].select { |coord| INDICES.include?(coord) }
end

def flash(coord, table, flashed)
  return if flashed.include?(coord)
  flashed << coord

  adjacent(*coord).each do |adj|
    table[adj] += 1
    flash(adj, table, flashed) if table[adj] > 9
  end
end

def step(table, flashed = Set.new)
  INDICES.each { |coord| table[coord] += 1 }

  INDICES.each do |coord|
    flash(coord, table, flashed) if table[coord] > 9
  end

  # Reset
  flashed.each do |coord|
    table[coord] = 0
  end

  flashed.count == INDICES.count
end

puts File
       .read('input')
       .each_line(chomp: true)
       .map { |l| l.split('').map(&:to_i) }
       .then(&method(:parse))
       .then { |table| (1..).each { |i| break i if step(table) } }
