require 'fileutils'
require 'json'
require 'pry'

require_relative 'lib/graphics.rb'

BASE_DIR = File.expand_path(File.dirname(__FILE__))

options = IOBench::OptionParser.parse!(ARGV.dup)

IOBench::OptionParser.validate_theme!(options[:theme])

input_filename = options[:input_filename] or raise("You must supply --i FILE_PATH")

data_formatter = options[:data_formatter]
graphic_type = options[:graphic_type]
group_by_key = options[:group_by_key]
metrics = options[:metrics]

report_data = File.read(File.join(BASE_DIR, 'results', input_filename))

json_data = JSON.parse(report_data)
data = IOBench::DataFormatter.group_data(json_data, group_by_key)

data.each do |test_mode, report_data|
  metrics.each do |metric|
    sample_report = report_data.first
    test_mode = sample_report[group_by_key]
    test_name = sample_report['test_name']
    test_type = sample_report['test_type']
    next if test_type.nil? || test_mode.nil?

    graphic_data = IOBench::DataFormatter.format_data(report_data, test_mode, metric, data_formatter)

    metric_label = IOBench::Graphic.label_for(metric)
    test_type_label = IOBench::Graphic.label_for(test_type)
    test_mode_label = IOBench::Graphic.label_for(test_mode)

    title = "#{metric_label}: #{test_type_label} #{test_mode_label}"
    image = "#{metric}_#{test_type}_#{test_mode}-#{graphic_type}.png"
    dir = File.join(BASE_DIR, "graphics", options[:theme] || '', test_type, test_name, graphic_type)
    filename = File.join(dir, image)

    FileUtils.mkdir_p(dir)

    graphic_options = options.dup.merge(title: title, labels: {})

    graphic = IOBench::Graphic.new(graphic_type, graphic_data, graphic_options)
    graphic.render(filename)
  end
end