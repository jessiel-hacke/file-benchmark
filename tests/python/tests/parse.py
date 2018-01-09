from tests.base import IOBenchBase

class IOBenchParse(IOBenchBase):
  FORMAT = [
    ("type",               2),
    ("sequential",         7),
    ("card_number",        19),
    ("auth_code",          6),
    ("sale_date",          8),
    ("sale_option",        1),
    ("sale_value",         15),
    ("installments",       3),
    ("zero0",              15),
    ("zero1",              15),
    ("zero2",              15),
    ("installment_value",  15),
    ("resume_number",      7),
    ("zero3",              3),
    ("entity_numbeer",     10),
    ("reserved0",          30),
    ("status",             2),
    ("payment_date",       8),
    ("expirty",            4),
    ("zero4",              7),
    ("zero5",              15),
    ("reserved1",          3),
    ("error_code",         4),
    ("ref",                11),
    ("new_card",           19),
    ("new_expiry",         4),
    ("reserved2",          2)
  ]

  def test_full(self, file_path):
    file  = open(file_path, 'r') # only read
    lines = file.readlines()
    for line in lines:
      self.parse(line)

  def test_stream(self, file_path):
    file = open(file_path, 'r') # only read
    for line in file:
      self.parse(line)

  def test_type(self):
    return 'parse'

  def parse(self, line):
    position = 0
    parsed = {}
    for name, size in IOBenchParse.FORMAT:
      parsed[name] = line[position:(position + size)]
      position += size
    return parsed

