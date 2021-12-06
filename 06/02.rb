puts File
  .read('input')
  .split(',')
  .map(&:to_i)
  .tally
  .tap { |spawn|
    256.times {
      to_spawn = spawn[0] || 0
      0.upto(7) do |i|
        spawn[i] = spawn[i+1] || 0
      end
      spawn[6] += to_spawn
      spawn[8] = to_spawn
    }
  }
  .values
  .sum
