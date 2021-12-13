def render(coords)
  max_x = coords.keys.map(&:first).max + 1
  max_y = coords.keys.map(&:last).max + 1

  (0..max_y).each do |y|
    (0..max_x).each do |x|
      print coords.key?([x, y]) ? "\u{2592}" : ' '
    end

    puts ''
  end
end

def fold(coords, axis, pos)
  coords.transform_keys! do |(x, y)|
    [
      (axis == :x && x > pos) ? pos - (x - pos) : x,
      (axis == :y && y > pos) ? pos - (y - pos) : y,
    ]
  end
end

File
  .read('input')
  .split("\n\n")
  .then { |values, folds|
    coords = values
      .each_line(chomp: true)
      .map { |el| el.split(',') }
      .each_with_object({}) { |pos, hash|
        hash[pos.map(&:to_i)] = 1
      }

    folds
      .scan(/([xy])\=(\d+)/)
      .each { |axis, pos| fold(coords, axis.to_sym, pos.to_i) }

    render coords
  }
