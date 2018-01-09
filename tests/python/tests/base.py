import os
import subprocess
import time
import platform

class IOBenchHelpers(object):
  def print_memory_usage(self, memory_before, memory_after):
    memory = ((memory_after - memory_before) / 1024.0)
    print("Memory: {0} MB".format(round(memory, 2)))

  def print_execution_time(self, elapsedTime):
    print("Time: {0}ms".format(round(elapsedTime, 2) * 1000))

  def capture_memory_usage(self, pid):
    command = "ps -o rss= -p {0}".format(pid)
    result = subprocess.check_output(command, shell=True)

    return float(result)

  def print_results(self, elapsedTime, memory_before, memory_after):
    self.print_memory_usage(memory_before, memory_after)
    self.print_execution_time(elapsedTime)

class IOBenchBase(IOBenchHelpers):
  def __init__(self, file_path, test_mode, test_name, verbose):
    self.file_path = file_path
    self.test_mode = test_mode
    self.test_name = test_name
    self.verbose = verbose
    # to keep content in memory through benchmark
    self.contents = None

  def run(self):
    if self.verbose:
      self.print_test_type()

    pid = os.getpid()
    memory_before = self.capture_memory_usage(pid)
    startTime = time.time()

    if (self.test_mode == 'full'):
      self.test_full(self.file_path)
    elif (self.test_mode == 'stream'):
      self.test_stream(self.file_path)

    memory_after = self.capture_memory_usage(pid)
    elapsedTime = (time.time() - startTime)

    if self.verbose:
      self.print_results(elapsedTime, memory_before, memory_after)

  def clear_file(self):
    file = open(self.file_path, 'w')
    file.truncate()
    file.close()

  def print_test_type(self):
    print(self.test_type_label())

  def test_type_label(self):
    return '''
Test Language: Python
Test Language Version: {0}
Test Type: {1}
Test Name: {2}
Test Mode: {3}
    '''.strip().format(platform.python_version(), self.test_type(), self.test_name, self.test_mode)