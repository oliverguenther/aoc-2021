class Core
  attr_accessor :ranges

  def initialize(ranges)
    self.ranges = ranges
  end

  def out_of_bounds?
    ranges.any? do |dim|
      dim.min < -50 || dim.max > 50
    end
  end

  def volume
    ranges.reduce(1) { |volume, dimension| volume * (dimension.max - dimension.min + 1) }
  end

  def overlaps?(other)
    ranges.each_with_index.all? do |a, i|
      b = other.ranges[i]
      a.include?(b.first) || b.include?(a.first)
    end
  end

  def overlapping_core(other)
    overlap = ranges.each_with_index.map do |a, i|
      b = other.ranges[i]

      [a.min, b.min].max..[a.max, b.max].min
    end

    Core.new(overlap)
  end
end

puts File
       .read('input')
       .each_line(chomp: true)
       .map { |l| l.match(/(on|off) x=(-?\d+\.\.-?\d+),y=(-?\d+\.\.-?\d+),z=(-?\d+\.\.-?\d+)/) }
       .map { |match| [[eval(match[2]), eval(match[3]), eval(match[4])], match[1] == 'on'] }
       .each_with_object({ :+ => [], :- => [] }) { |(range, on), state|
         cube = Core.new(range)
         next if cube.out_of_bounds?

         new_state = { :+ => [], :- => [] }
         state[:+].each do |other|
           next unless cube.overlaps?(other)

           new_state[:-] << cube.overlapping_core(other)
         end

         state[:-].each do |other|
           next unless cube.overlaps?(other)

           new_state[:+] << cube.overlapping_core(other)
         end

         new_state[:+] << cube if on

         state[:+] += new_state[:+]
         state[:-] += new_state[:-]
       }
       .then { |state|
         state.reduce(0) do |sum, (method, cubes)|
           cubes.reduce(sum) { |sum, cube| sum.send(method, cube.volume) }
         end
       }
