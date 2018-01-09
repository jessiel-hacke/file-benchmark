require "./base"

module IOBench
  class Parse < Base
    FORMAT = {
      type:               2,
      sequential:         7,
      card_number:        19,
      auth_code:          6,
      sale_date:          8,
      sale_option:        1,
      sale_value:         15,
      installments:       3,
      zero0:              15,
      zero1:              15,
      zero2:              15,
      installment_value:  15,
      resume_number:      7,
      zero3:              3,
      entity_numbeer:     10,
      reserved0:          30,
      status:             2,
      payment_date:       8,
      expirty:            4,
      zero4:              7,
      zero5:              15,
      reserved1:          3,
      error_code:         4,
      ref:                11,
      new_card:           19,
      new_expiry:         4,
      reserved2:          2
    }

    def test_full(file_path)
      File.read_lines(file_path).each do |line|
        parse(line)
      end
    end

    def test_stream(file_path)
      File.each_line(file_path) do |line|
        parse(line)
      end
    end

    def test_type
      "parse"
    end

    private def parse(line : String)
      position = 0
      parsed = {} of (Symbol|String) => String
      FORMAT.each do |key, size|
        parsed[key] = line[position...(position+size)]
        position = position + size
      end
      parsed
    end
  end
end
