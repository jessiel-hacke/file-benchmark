from tests.base import IOBenchBase
from itertools import repeat

class IOBenchWrite(IOBenchBase):

  BYTES_PER_LINE = 1024 # 1 kb
  DUMMY_CHARACTER = " " # space as 1 byte char

  def __init__(self, block_size, file_path, test_mode, test_name, verbose):
    self.block_size = block_size
    self.file_path = file_path
    self.test_mode = test_mode
    self.test_name = test_name
    self.verbose = verbose
    # to keep content in memory through benchmark
    self.contents = None
    self.clear_file()

  def test_full(self, file_path):
    file = open(file_path, 'w+')
    self.contents = self.generate_dummy_data(self.block_size)
    file.write(self.contents)
    file.flush()

  def test_stream(self, file_path):
    file = open(file_path, 'w+')
    for i in repeat(None, self.block_size):
      file.write(self.generate_dummy_data(1))

  def generate_dummy_data(self, block_size=1):
    return IOBenchWrite.DUMMY_CHARACTER * (IOBenchWrite.BYTES_PER_LINE * block_size)

  def test_type(self):
    return 'write'