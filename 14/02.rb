require 'pry'

def step(occurrences, mapping)
  occurrences.each_with_object(Hash.new(0)) do |((a, b), count), occ_next|
    insert = mapping[[a, b]]
    next unless insert

    occ_next[[a, insert]] += count
    occ_next[[insert, b]] += count
  end
end

puts File
       .read('input')
       .split("\n\n")
       .then { |template_str, mapping|
         lookup = mapping
           .each_line(chomp: true)
           .map { |el| el.split(' -> ') }
           .each_with_object({}) { |(from, to), hash|
             hash[from.chars] = to
           }

         occurrences = Hash.new(0)
         template_str
           .chars
           .each_cons(2) { |a, b| occurrences[[a, b]] += 1 }

         40.times {  occurrences = step(occurrences, lookup) }
         occurrences[[template_str.chars.last, nil]] += 1
         char_occurrence = occurrences.each_with_object(Hash.new(0)) do |((a, _), count), counts|
           counts[a] += count
         end

         min = char_occurrence.min_by { |k, v| v }.last
         max = char_occurrence.max_by { |k, v| v }.last

         max - min
       }
