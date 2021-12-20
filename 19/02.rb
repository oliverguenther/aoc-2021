require 'pry'
require 'set'

def permutations(inputs)
  [
    inputs.map { |x, y, z| [x, y, z] },
    inputs.map { |x, y, z| [-x, y, z] },
    inputs.map { |x, y, z| [-x, y, -z] },
    inputs.map { |x, y, z| [-x, -y, z] },
    inputs.map { |x, y, z| [x, -y, z] },
    inputs.map { |x, y, z| [x, -y, -z] },
    inputs.map { |x, y, z| [x, y, -z] },
    inputs.map { |x, y, z| [-x, -y, -z] },

    inputs.map { |x, y, z| [x, z, y] },
    inputs.map { |x, y, z| [-x, z, y] },
    inputs.map { |x, y, z| [-x, -z, y] },
    inputs.map { |x, y, z| [x, -z, y] },
    inputs.map { |x, y, z| [-x, z, -y] },
    inputs.map { |x, y, z| [x, -z, -y] },
    inputs.map { |x, y, z| [x, z, -y] },
    inputs.map { |x, y, z| [-x, -z, -y] },

    inputs.map { |x, y, z| [z, y, x] },
    inputs.map { |x, y, z| [-z, y, x] },
    inputs.map { |x, y, z| [-z, -y, x] },
    inputs.map { |x, y, z| [z, -y, x] },
    inputs.map { |x, y, z| [-z, y, -x] },
    inputs.map { |x, y, z| [z, -y, -x] },
    inputs.map { |x, y, z| [z, y, -x] },
    inputs.map { |x, y, z| [-z, -y, -x] },

    inputs.map { |x, y, z| [z, x, y] },
    inputs.map { |x, y, z| [-z, x, y] },
    inputs.map { |x, y, z| [-z, -x, y] },
    inputs.map { |x, y, z| [z, -x, y] },
    inputs.map { |x, y, z| [-z, x, -y] },
    inputs.map { |x, y, z| [z, -x, -y] },
    inputs.map { |x, y, z| [z, x, -y] },
    inputs.map { |x, y, z| [-z, -x, -y] },

    inputs.map { |x, y, z| [y, x, z] },
    inputs.map { |x, y, z| [-y, x, z] },
    inputs.map { |x, y, z| [-y, -x, z] },
    inputs.map { |x, y, z| [y, -x, z] },
    inputs.map { |x, y, z| [-y, x, -z] },
    inputs.map { |x, y, z| [y, -x, -z] },
    inputs.map { |x, y, z| [y, x, -z] },
    inputs.map { |x, y, z| [-y, -x, -z] },

    inputs.map { |x, y, z| [y, z, x] },
    inputs.map { |x, y, z| [-y, z, x] },
    inputs.map { |x, y, z| [-y, -z, x] },
    inputs.map { |x, y, z| [y, -z, x] },
    inputs.map { |x, y, z| [-y, z, -x] },
    inputs.map { |x, y, z| [y, -z, -x] },
    inputs.map { |x, y, z| [y, z, -x] },
    inputs.map { |x, y, z| [-y, -z, -x] },
  ]
end

def normalize!(normalized, candidates)
  puts "================"
  puts "Testing #{candidates.count} scanners "
  puts "Found #{normalized.count} normalized "
  puts "================"

  candidates.each_with_index do |all_permutations, scanner_idx|
    all_permutations.each_with_index do |permutation, permut_idx|
      puts "Testing #{scanner_idx + 1} / #{candidates.count}, #{permut_idx + 1} / #{all_permutations.count}"
      normalized.each do |n_x, n_y, n_z|
        permutation.each_with_index do |(t_x, t_y, t_z), i|
          break if (i + 11) >= permutation.count

          dx = n_x - t_x
          dy = n_y - t_y
          dz = n_z - t_z

          matched = 0
          permutation[(i + 1)..-1].each do |x, y, z|
            matched += 1 if normalized.include?([x + dx, y + dy, z + dz])
            if matched >= 11
              puts "MATCH!"
              return scanner_idx,
                permutation.map { |x, y, z| [x + dx, y + dy, z + dz] },
                [dx, dy, dz]
            end
          end
        end
      end
    end
  end
end

puts File
       .read('input')
       .split(/--- scanner \d+ ---/)
       .drop(1)
       .map { |data|
         data
           .each_line(chomp: true)
           .reject(&:empty?)
           .map { |coords| coords.split(",").map(&:to_i) }
       }
       .then { |input|
         normalized = Set.new input.shift

         scanners = input.map(&method(:permutations))

         distances = [[0, 0, 0]]

         until scanners.empty?
           found, positions, deltas = normalize!(normalized, scanners)
           normalized += positions
           distances << deltas
           scanners.delete_at(found)
         end

         distances
           .combination(2)
           .reduce(0) { |max, (a, b)|
             val = [
               (a[0] - b[0]).abs,
               (a[1] - b[1]).abs,
               (a[2] - b[2]).abs,
             ]

             [max, val.sum].max
           }
       }
