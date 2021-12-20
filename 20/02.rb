def to_algo_index(input, x, y)
  [
    [x - 1, y - 1],
    [x - 1, y],
    [x - 1, y + 1],
    [x, y - 1],
    [x, y],
    [x, y + 1],
    [x + 1, y - 1],
    [x + 1, y],
    [x + 1, y + 1]
  ]
    .map { |point| input[point] ? '1' : '0' }
    .join
    .to_i(2)
end

def dimensions(image)
  min_x = 0
  min_y = 0
  max_x = 0
  max_y = 0

  image.each_key do |(x, y)|
    min_x = [min_x, x].min
    max_x = [max_x, x].max
    min_y = [min_y, y].min
    max_y = [max_y, y].max
  end

  [min_x, min_y, max_x, max_y]
end

def apply_algo(algo, input, i)
  min_x, min_y, max_x, max_y = dimensions(input)
  # input has algo[0] == '#', which means it
  # has to be the default for the first projection
  output = Hash.new(i % 2 == 0)

  (min_x - 1).upto(max_x + 1) do |x|
    (min_y - 1).upto(max_y + 1) do |y|
      i = to_algo_index(input, x, y)
      output[[x, y]] = algo[i]
    end
  end

  output
end

puts File
       .read('input')
       .split("\n\n")
       .then { |data|
         algo = data
           .shift
           .gsub("\n", "")
           .chars
           .map { |char| char == '#' }

         image = Hash.new
         data.last.each_line(chomp: true).each_with_index { |l, i|
           l.chars.each_with_index { |char, j|
             image[[i, j]] = char == '#'
           }
         }

         [algo, image]
       }
       .then { |algo, image| 50.times { |i| image = apply_algo(algo, image, i) }; image }
       .then { |image| image.count { |_, v| v } }
