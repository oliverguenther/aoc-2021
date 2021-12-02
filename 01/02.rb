lines = File.read('input').lines(chomp: true)

count = 0
lines.each_with_index do |_, i|
  cur_window = lines[i..(i + 2)].map(&:to_i)
  next_window = lines[(i + 1)..(i + 3)].map(&:to_i)

  if cur_window.count != 3 || next_window.count != 3
    puts "#{cur_window.inspect} or #{next_window.inspect} out of bounds. Count is #{count}"
    break
  end

  if next_window.sum > cur_window.sum
    puts "FOUND   #{next_window.inspect} > #{cur_window.inspect} sum #{next_window.sum} > #{cur_window.sum}"
    count += 1
  else
    puts "NOFOUND #{next_window.inspect} > #{cur_window.inspect} sum #{next_window.sum} <= #{cur_window.sum}"
  end
end

