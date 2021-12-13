def fold(coords, axis, pos)
  coords.transform_keys! do |(x, y)|
    [
      (axis == :x && x > pos) ? pos - (x - pos) : x,
      (axis == :y && y > pos) ? pos - (y - pos) : y,
    ]
  end
end

puts File
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
           .first
           .then { |axis, pos| fold(coords, axis.to_sym, pos.to_i) }

         coords.count
       }
