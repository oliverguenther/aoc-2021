require 'pry'

def evaluate(t_xrange, t_yrange)
  y_max = 0
  (1..t_xrange.max).to_a.product((-1000..1000).to_a).each do |vx, vy0|
    max_pos = 0
    x = 0
    y = 0
    vy = vy0

    while x <= t_xrange.max && y >= t_yrange.min
      max_pos = [max_pos, y + vy].max
      x += vx
      y += vy
      vx -= 1 if vx > 0
      vy -= 1

      in_x = t_xrange.include?(x)
      in_y = t_yrange.include?(y)

      if in_x && in_y
        y_max = [y_max, max_pos].max
        break
      end
    end
  end

  y_max
end

puts File
       .read('input')
       .match(/x=(-?\d+)\.\.(-?\d+), y=(-?\d+)\.\.(-?\d+)/)
       .then { evaluate($1.to_i..$2.to_i, $3.to_i..$4.to_i)}
