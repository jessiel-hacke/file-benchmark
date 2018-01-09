require 'pry'
require 'json'

module IOBench
  module Normalizer

    REGEXPS = {
      :language_version_num => /(\d.\d.\d)/,
      :language_version => /Test Language Version: (.*)/,
      :time_shell => /Shell Execution Time: (.*)/,
      :test_type => /Test Type: (\w+)/,
      :test_mode => /Test Mode: (\w+)/,
      :test_name => /Test Name: (\w+)/,
      :language => /Test Language: (\w+)/,
      :memory => /Memory: (.*)/,
      :time => /Time: (.*)/
    }.freeze


    module_function
    def parse_data(data)
      {
        language: extract_language(data),
        language_version: extract_language_version(data),
        language_version_num: extract_language_version_num(data),
        test_type: extract_test_type(data),
        test_name: extract_test_name(data),
        test_mode: extract_test_mode(data),
        memory_usage: extract_memory_usage(data),
        time_spent: extract_time_spent(data),
        time_spent_shell: extract_time_spent_shell(data)
      }
    end

    def extract_language(data)
      apply_regexp(data, :language)
    end

    def extract_language_version(data)
      apply_regexp(data, :language_version)
    end

    def extract_language_version_num(data)
      version = apply_regexp(data, :language_version) || 'undefined'

      apply_regexp(version, :language_version_num).to_s
    end

    def extract_test_type(data)
      apply_regexp(data, :test_type)
    end

    def extract_test_name(data)
      apply_regexp(data, :test_name)
    end

    def extract_test_mode(data)
      apply_regexp(data, :test_mode)
    end

    def extract_memory_usage(data)
      apply_regexp(data, :memory)
    end

    def extract_time_spent_shell(data)
      apply_regexp(data, :time_shell)
    end

    def extract_time_spent(data)
      time_spent = apply_regexp(data, :time)

      #return (time_spent.to_f / 1000).to_s if time_spent.match(/µs$/)

      #return time_spent.to_s if data.match(/GoLang|NodeJS/) && time_spent.match(/ms$/)

      time_spent.to_s
    end

    def apply_regexp(data, regexp_id)
      data.match(REGEXPS[regexp_id.to_sym]) && $1
    end
  end
end


def run(env)
  input_filename = env['SOURCE_FILENAME']
  output_filename = env['DEST_FILENAME']

  filename = File.join(File.dirname(__FILE__), 'results', input_filename)
  dest_filename = File.join(File.dirname(__FILE__), 'results', output_filename)
  file = File.open(filename, 'r')

  puts "Creating #{dest_filename} from #{filename}"

  data = file.read
  data_per_language = data.split("\n\n")

  parse_data = lambda {|data| IOBench::Normalizer.parse_data(data) }

  File.open(dest_filename, 'wb') do |file|
    content = data_per_language.map {|language_data| parse_data.call(language_data) }

    file.write(JSON.pretty_generate(content))
  end
end


run(ENV) if $0 == __FILE__ # someone is executing this file