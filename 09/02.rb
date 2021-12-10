require 'set'

def detect_lows(hm)
  lows = []
  cols = hm[0].count
  rows = hm.count

  hm.each_index do |i|
    hm[i].each_index do |j|
      min = [
        (hm[i - 1][j] if i > 0),
        (hm[i + 1][j] if i < rows - 1),
        (hm[i][j - 1] if j > 0),
        (hm[i][j + 1] if j < cols - 1),
      ].compact.min

      el = hm[i][j]
      lows << [i, j] if el < min
    end
  end

  lows
end

def fill_basin(hm, i, j, basin: [], seen:)
  return if i < 0 || j < 0
  return if i >= hm.count || j >= hm[0].count
  return if seen.include?([i, j])

  val = hm[i]&.fetch(j, nil)
  return if val.nil? || val == 9

  basin << val
  seen << [i, j]
  fill_basin(hm, i - 1, j, basin: basin, seen: seen)
  fill_basin(hm, i + 1, j, basin: basin, seen: seen)
  fill_basin(hm, i, j - 1, basin: basin, seen: seen)
  fill_basin(hm, i, j + 1, basin: basin, seen: seen)

  basin
end

def fill_lows(hm, lows)
  seen = Set.new
  lows.map do |i, j|
    next if seen.include?([i, j])
    fill_basin(hm, i, j, seen: seen)
  end
end

puts File
       .read('input')
       .each_line(chomp: true)
       .map { |l| l.split('').map(&:to_i) }
       .then { |hm| [hm, detect_lows(hm)] }
       .then { |hm, lows| fill_lows(hm, lows) }
       .map(&:count)
       .sort
       .reverse
       .take(3)
       .reduce(:*)


