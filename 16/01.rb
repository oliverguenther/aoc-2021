require 'stringio'

class Packet
  attr_reader :version, :id

  def initialize(version, id)
    @version = version
    @id = id
  end
end

class OpPacket < Packet
  attr_reader :packages

  def initialize(version, id, io)
    super(version, id)
    @packages = parse(io)
  end

  def version_sum
    version + packages.map(&:version_sum).sum
  end

  private

  def parse(io)
    mode = io.read(1).to_i(2)
    packets = []

    if mode == 0
      bits = io.read(15).to_i(2)
      to_read = io.pos + bits
      until io.pos == to_read
        packets << packet(io)
      end
    else
      count = io.read(11).to_i(2)
      count.times { packets << packet(io) }
    end

    packets
  end
end

class ValuePacket < Packet
  attr_reader :value

  def initialize(version, id, io)
    super(version, id)
    @value = parse(io)
  end

  def version_sum
    version
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
       .then { |main| main.version_sum }
