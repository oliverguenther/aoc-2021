File.open('input') do |f|
  count = f
    .each_line(chomp: true)
    .map(&:to_i)
    .each_cons(3)
    .each_cons(2)
    .count { |a, b| b.sum > a.sum }

  puts count
end
