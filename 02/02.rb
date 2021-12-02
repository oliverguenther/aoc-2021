File.open('input') do |f|
  x, y, _ = f
    .each_line(chomp: true)
    .map { |l| l.split(' ') }
    .inject([0, 0, 0]) do |(x, y, aim), (cmd, val)|
    delta = val.to_i

    case cmd
    when 'forward'
      [x + delta, y + (aim * delta), aim]
    when 'down'
      [x, y, aim + delta]
    when 'up'
      [x, y, aim - delta]
    end
  end

  puts "horizontal=#{x}, depth=#{y}, result=#{x * y}"
end
