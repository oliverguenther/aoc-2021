def cost(positions, target)
  positions.reduce(0) { |sum, position|
    delta = (position - target).abs
    sum + ((delta * (delta + 1)) / 2.0).round
  }
end

puts File
  .read('input')
  .split(',')
  .map(&:to_i)
  .sort
  .then { |positions|
    (0..positions.max)
      .reduce(nil) do |prev, target|
      cur = cost(positions, target)
      if prev.nil? || cur < prev
        cur
      elsif cur > prev
        break prev
      else
        prev
      end
    end
  }
