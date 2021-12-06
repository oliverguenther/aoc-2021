puts File
  .read('input')
  .split(',')
  .map(&:to_i)
  .tally
  .tap { |spawn|
    spawn.default = 0
    80.times {
      to_spawn = spawn[0]
      0.upto(7) do |i|
        spawn[i] = spawn[i+1]
      end
      spawn[6] += to_spawn
      spawn[8] = to_spawn
    }
  }
  .values
  .sum
