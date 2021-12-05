puts File
  .read('input')
  .each_line(chomp: true)
  .map { |l| l.split(/ -> |,/).map(&:to_i) }
  .select { |x1, y1, x2, y2| x1 == x2 || y1 == y2 }
  .map { |x1, y1, x2, y2|
     x = x1 == x2 ? [x1].cycle((y2 - y1).abs + 1) : x1.step(x2, x1 > x2 ? -1 : 1)
     y = y1 == y2 ? [y1].cycle : y1.step(y2, y1 > y2 ? -1 : 1)
     x.zip y
   }
  .flatten(1)
  .each_with_object(Hash.new(0)) { |coord, field| field[coord] += 1 }
  .count { |_, v| v >= 2 }
