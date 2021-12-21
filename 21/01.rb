require 'pry'
Player = Struct.new(:pos, :score, keyword_init: true)

puts File
       .read('input')
       .each_line(chomp: true)
       .map { |l| l.match(/Player \d+ starting position: (\d+)/) }
       .map { |match| Player.new(pos: match[1].to_i, score: 0) }
       .then { |players|
         rolls = 0
         turn = 0

         loop do
           sum = 0

           3.times do
             rolls += 1
             sum += (rolls % 100)
           end

           players[turn].pos = (players[turn].pos + sum) % 10
           players[turn].score += players[turn].pos == 0 ? 10 : players[turn].pos

           if players[turn].score >= 1000
             other = turn == 0 ? players.last : players.first
             puts "Winning #{players[turn]}"
             puts "Losing  #{other}"
             puts "Rolls #{rolls}"
             break other.score * rolls
           end

           turn = (turn + 1) % players.count
         end
       }
