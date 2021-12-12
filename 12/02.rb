def cancel?(node, path)
  return false unless node.downcase == node

  node_count = path.count(node)
  has_double = path.detect { |seg| node != seg && seg.downcase == seg && path.count(seg) > 1 }

  (node_count == 1 && has_double) || node_count >= 2
end

def explore(pathmap, node = :start, path = [], paths = [])
  return paths if cancel?(node, path)

  path << node

  if node == :end
    paths << path
    return paths
  end

  pathmap[node].each do |target|
    next if target == :start
    explore(pathmap, target, path.dup, paths)
  end

  paths
end

puts File
       .read('input')
       .each_line(chomp: true)
       .map { |l| l.split('-').map(&:to_sym) }
       .each_with_object(Hash.new([])) { |(from, to), hash|
         hash[from] += [to]
         hash[to] += [from]
       }
       .then(&method(:explore))
       .count
