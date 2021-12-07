puts File
  .read('input')
  .split(',')
  .map(&:to_i)
  .sort
  .then { |positions|
    mean = (positions[(positions.count - 1) / 2] + positions[positions.count / 2]) / 2
    positions.reduce(0) { |sum, position|
      sum + (position - mean).abs
    }
  }
