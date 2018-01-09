require 'pry'
require 'fileutils'
require 'securerandom'


ROOT_DIR = Dir.pwd
BYTES_PER_LINE = 1024
FORCE = ENV['FORCE'] == 'true'

max_kbs = (10..200).step(10).map {|kb| mb = (kb * 1024) } # 10, 20, 30
min_kbs = %w(1 2 4 8 16 32 64 128 256 512 1024 2048).map(&:to_i)

FileUtils.mkdir_p(File.join(ROOT_DIR, 'data', 'read'))

def generate_dummy_data(block_size=1)
  bytes = (BYTES_PER_LINE * block_size)
  SecureRandom.hex(bytes/2) << "\n"
end

def create_file(block_size, filename)
  file = File.open(filename, 'wb')

  block_size.times do
    file.puts(generate_dummy_data(1))
  end

  file.flush()
end

min_kbs.each do |block_size|
  filename = "#{ROOT_DIR}/data/read/#{block_size}_kb.txt"
  if !File.exists?(filename) || FORCE
    create_file(block_size, filename)
  end
end

max_kbs.each do |block_size|
  filename = "#{ROOT_DIR}/data/read/#{(block_size/1024)}_mb.txt"
  if !File.exists?(filename) || FORCE
    create_file(block_size, filename)
  end
end