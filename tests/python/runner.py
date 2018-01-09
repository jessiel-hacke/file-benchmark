import os
import tests.base
from tests.read import IOBenchRead
from tests.write import IOBenchWrite
from tests.parse import IOBenchParse

class IOBenchRunner:
  def start(self, env):
    file_path  = env.get('TEST_FILE')
    test_type  = env.get('TEST_TYPE')
    test_mode  = (env.get('TEST_MODE') or 'full').lower()
    test_name  = (env.get('TEST_NAME') or os.path.basename(file_path))
    verbose    = (env.get('VERBOSE') == 'true')
    block_size = (int) (env.get('KB_BLOCK_SIZE') or 1)

    if test_type == None:
      raise(Exception('You must suply TEST_TYPE with one the values: read, write, read+write'))

    if test_type == 'read':
      bench = IOBenchRead(file_path, test_mode, test_name, verbose)
      bench.run()
    elif test_type == 'write':
      bench = IOBenchWrite(block_size, file_path, test_mode, test_name, verbose)
      bench.run()
    elif test_type == 'parse':
      bench = IOBenchParse(file_path, test_mode, test_name, verbose)
      bench.run()


IOBenchRunner().start(os.environ)