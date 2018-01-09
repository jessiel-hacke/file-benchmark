require 'pry'
require 'gruff'
require 'optparse'

class String
  unless method_defined?(:camelize)
    def camelize(uppercase_first_letter = true)
      string = self
      if uppercase_first_letter
        string = string.sub(/^[a-z\d]*/) { $&.capitalize }
      else
        string = string.sub(/^(?:(?=\b|[A-Z_])|\w)/) { $&.downcase }
      end
      string.gsub(/(?:_|(\/))([a-z\d]*)/) { "#{$1}#{$2.capitalize}" }.gsub('/', '::')
    end
  end
end

module IOBench
  class Graphic

    METRICS_LABEL = {
      memory_usage: 'Uso de memória (MB)',
      time_spent: 'Tempo (ms)',
      time_spent_shell: 'Tempo exec (secs)',
      read: 'Leitura',
      write: 'Escrita',
      parse: 'Parse',
      full: 'única',
      stream: 'linha-a-linha'
    }

    DEFAULT_SIZE = '1024x768'

    LANGUAGE_COLORS = {
      ruby: '#CC342D',    # ruby color
      crystal: '#8740a9', # crystal logo color
      python: '#3670a0',  # 'blue' color of snake (in logo)
      lua: '#00007f',     # blue from site
      nodejs: '#f7df1e',  # javascript yellow from logo
      golang: '#69d7e2',  # Go Gopher
      elixir: '#8c002f'   # erlang logo color
    }

    attr_reader :graph_object

    def initialize(graphic_type, datasets, options = {})
      options[:size] ||= DEFAULT_SIZE

      @original_datasets = datasets
      @graph_object = graphic_from_options(graphic_type, datasets, options)

      self
    end

    def render(filename)
      @graph_object.write(filename)
    end
    alias :write :render

    def self.label_for(metric)
      METRICS_LABEL[metric.to_sym] unless metric.nil?
    end

    private
    def graphic_color_for(language)
      LANGUAGE_COLORS[language.to_sym]
    end

    def graphic_language_color(language)
      graphic_color_for(language.to_s.split("-").first.downcase)
    end

    def graphic_from_options(graphic_type, datasets, options)
      graphic = graphic_class(graphic_type).new(options[:size])
      apply_styles(apply_datasets(graphic, datasets), options)
    end

    def apply_datasets(graphic, datasets)
      # get max values array
      min_max = datasets.map {|d| d[1] }.flatten

      datasets.each do |data|
        graphic.data(data[0], data[1], graphic_language_color(data[0]))
      end

      graphic.maximum_value = ((min_max.max * 1.8))
      graphic.minimum_value = 0

      graphic
    end

    def apply_styles(graphic, options = {})
      graphic.title = options[:title]
      graphic.labels = options[:labels]

      graphic.show_labels_for_bar_values = !!options[:show_values] || true

      graphic.title_margin = options[:title_margin] || 30
      graphic.legend_margin = options[:legend_margin] || 20
      graphic.legend_box_size = options[:legend_box_size] || 20

      graphic.marker_count = options[:marker_count] if options[:marker_count]
      graphic.y_axis_label = options[:y_axis_label] if options[:y_axis_label]
      graphic.spacing_factor = options[:spacing_factor] if options[:spacing_factor]

      graphic.theme = theme_from_option(options[:theme])

      graphic
    end

    def graphic_class(graphic_type)
      Gruff.const_get(graphic_type.camelize)
    end

    def theme_from_option(option_string)
      Gruff::Themes.const_get(option_string.to_s.upcase)
    end

    def labels_for(metric)
      label = self.class.label_for(metric)
      { 0 => label }
    end
  end

  class OptionParser
    AVAILABLE_THEMES = Gruff::Themes.constants.sort.map {|theme| theme.to_s.downcase }

    DEFAULT_METRICS = [
      :memory_usage,
      :time_spent,
      :time_spent_shell
    ]

    DEFAULT_OPTIONS = {
      :theme => 'pastel',
      :metrics => DEFAULT_METRICS,
      :graphic_type => 'bar',
      :group_by_key => 'test_mode',
      :data_formatter => :default
    }

    def self.parse!(options)
      options = default_options

      parser = ::OptionParser.new do |parser|
        parser.banner = "Usage: generate-graphics.rb [options]"
        parser.separator ""
        parser.separator "Specific options:"

        parser.on('-g', '--graphic_type=GRAPHIC_TYPE', "Type of graphic to be generated") do |value|
          options[:graphic_type] = value
        end

        parser.on('-i', '--input_file=INPUT_FILE', "JSON Input with Graphic data") do |value|
          options[:input_filename] = value
        end

        parser.on('-f', '--formatter=FORMATTER_NAME', "Data formatter") do |value|
          options[:data_formatter] = value
        end

        parser.on('-m', '--metrics=METRICS', "Metrics to be reported. Must comma separated") do |value|
          options[:metrics] = value.squish.split(',').map(&:squish)
        end

        parser.on('-k', '--group_key=GROUP_KEY', "Key used to group dataset to generate graphics") do |value|
          options[:group_by_key] = value
        end

        parser.on('-mc', '--marker_count=MARKER_COUNT', "Number of markers in graphic (default nil)") do |value|
          options[:marker_count] = value
        end

        parser.on('--t', '--theme_name=THEME_NAME', "Graphic style theme. Avaliable #{AVAILABLE_THEMES}") do |value|
          options[:theme] = value.downcase
        end

        parser.on("-h", "--help", "Prints this help") do
          puts parser
          exit
        end

      end.parse!

      options
    end

    def self.default_options
      DEFAULT_OPTIONS
    end

    def self.validate_theme!(theme_name)
      if theme_name && !(AVAILABLE_THEMES.member?(theme_name.to_s.downcase))
        raise("Invalid theme name = #{theme_name}. Valid values are one of: #{AVAILABLE_THEMES.join(', ')}")
      end
    end
  end

  module DataFormatter
    module Base
    end

    module Default
      def self.format_data(data, metric = 'memory_usage', identifiers = 'language,language_version_num')
        data = [data] unless data.is_a?(Array)

        data.map do |data|
          id = identifiers.split(',').map {|id| data[id.to_s] }.join('-')
          [ id, [ data[metric.to_s].to_f] ]
        end
      end
    end

    def self.format_data(raw_data, group_by_key, metric, formatter = :default)
      DataFormatter.const_get(formatter.to_s.camelize).format_data(raw_data, metric)
    end

    def self.group_data(raw_data, group_by_key)
      raw_data.group_by {|data| data[group_by_key] }
    end
  end
end