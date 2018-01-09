from tests.base import IOBenchBase

class IOBenchRead(IOBenchBase):
  def test_full(self, file_path):
    file = open(file_path, 'r') # only read
    self.contents = file.read()

  def test_stream(self, file_path):
    file = open(file_path, 'r') # only read
    for line in file:
        self.contents = line

  def test_type(self):
    return 'read'