require 'stringio'

class Packet
  attr_reader :version, :id

  def initialize(version, id)
    @version = version
    @id = id
  end
end

class OpPacket < Packet
  attr_reader :value

  def initialize(version, id, io)
    super(version, id)
    @value = value_from parse(io)
  end

  private

  def value_from(packages)
    case id
    when 0
      packages.sum
    when 1
      packages.reduce(:*)
    when 2
      packages.min
    when 3
      packages.max
    when 5, 6, 7
      cmp = { 5 => :>, 6 => :<, 7 => :== }[id]
      val = packages.first.send(cmp, packages.last)
      val ? 1 : 0
    end
  end

  def parse(io)
    mode = io.read(1).to_i(2)
    values = []

    if mode == 0
      bits = io.read(15).to_i(2)
      to_read = io.pos + bits
      until io.pos == to_read
        values << packet(io).value
      end
    else
      count = io.read(11).to_i(2)
      count.times { values << packet(io).value }
    end

    values
  end
end

class ValuePacket < Packet
  attr_reader :value

  def initialize(version, id, io)
    super(version, id)
    @value = parse(io)
  end

  private

  def parse(io)
    number = ''
    lead = '1'
    while lead == '1' do
      lead = io.read(1)
      number << io.read(4)
    end

    number.to_i(2)
  end
end

def packet(io)
  version = io.read(3).to_i(2)
  id = io.read(3).to_i(2)

  case id
  when 4
    ValuePacket.new(version, id, io)
  else
    OpPacket.new(version, id, io)
  end
end

puts File
       .read('input')
       .chars
       .map { |val| val.hex.to_s(2).rjust(4, '0') }
       .join
       .then { |binary| packet StringIO.new(binary) }
       .then { |main| main.value }
