require 'forwardable'
require 'logger'
require 'rainbow'

# This file contains helper methods for Advent of Code problems.
# Some functionality is shared between problems, so it is placed here to avoid duplication.
module AdventHelpers

  # Loads input and processes it to the yielded block line by line.
  # If the input is a filename, it is loaded from the inputs directory.
  # If the input is a heredoc string, it is processed directly.
  #
  # @param input_file [String] The name of the input file.
  # @yield [String] Each line in the file.
  # @return [nil]
  def self.load_input_and_do(input, &block)
    if input.include?("\n")
      input.each_line do |line|
        block.call(line)
      end
      return
    end
    path = File.expand_path('../inputs', __dir__)
    full_path = File.join(path, input)
    file = File.open(full_path, "r")
    file.readlines.each do |line|
      block.call(line) if line.strip.length > 0
    end
  end

  def self.print_christmas_header(day, puzzle_name)
    width = 30 # Adjust based on your desired total width
    Engine::Logger.header { "*" * width }
    Engine::Logger.header { "~~~ 2024 Advent of Code ~~~".center(width) }
    Engine::Logger.header { "*" * width }
    Engine::Logger.header { ("[Day #{day.to_s.rjust(2, '0')}]").center(width) }
    Engine::Logger.header { "[#{puzzle_name.center(width)}]" }
    Engine::Logger.header { "*" * width }
    Engine::Logger.header { "*        Merry Coding!       *".center(width) }
    Engine::Logger.header { "*" * width }
  end


end



module Engine

  class AdventLogger < Logger

    module Severity
      DEBUG = 0
      INFO = 1
      HEADER = 2
      WARN = 3
      ERROR = 4
      FATAL = 5
      UNKNOWN = 6
      ACTION = 7

      COLORS = {
        DEBUG => {default: :gray, highlight: :white},
        INFO => {default: :blue, highlight: :white},
        WARN => {default: :yellow, highlight: :red},
        ERROR => {default: :red, highlight: :white, decorators: [:underline]},
        FATAL => {default: :red, highlight: :white, background: :black, decorators: [:bright, :underline]},
        UNKNOWN => {default: :red, highlight: :white},
        HEADER => {default: :blue, highlight: :cyan},
        ACTION => {default: :magenta, highlight: :cyan}
      }.freeze
    end
    prepend Severity

    def initialize(logdev, shift_age = 0, shift_size = 1048576, level: DEBUG,
                   progname: nil, formatter: nil, datetime_format: nil,
                   binmode: false, shift_period_suffix: '%Y%m%d')
      super
    end

    SEVS = %w(DEBUG INFO HEADER WARN ERROR FATAL UNKNOWN ACTION VALIDATION VALIDATION_FAIL)
    def format_severity(severity)
      SEVS[severity] || 'ANY'
    end

    def header(progname = nil, &block)
      add(HEADER, nil, progname, &block)
    end

    def action(progname = nil, &block)
      add(ACTION, nil, progname, &block)
    end

    def fatal(progname = nil, &block)
      add(FATAL, nil, progname, &block)
      raise progname
    end

    def add(severity, message = nil, progname = nil)
      return true if @logdev.nil? or severity < level
      super
      Rainbow.enabled = false
      message = format_message(format_severity(severity), Time.now, @progname, message || progname)
      Rainbow.enabled = true
      true
    end

    def level=(severity)
      @level = (severity.is_a? Integer) ? severity : SEVS.index(severity.to_s.upcase)
    end

  end

  module ColoredLogger
    extend self
    extend Forwardable
    attr_accessor :logger
    def_delegators :@logger, *Logger.instance_methods(false)
    def_delegators :@logger, *AdventLogger.instance_methods(false)
    Severity = AdventLogger::Severity
    SEV_MAX_LENGTH = AdventLogger::SEVS.max_by(&:length).length

    class Formatter < ::Logger::Formatter
      Format = "%s, [%s#%d] {%5s} -- %s: %s\n".freeze
      def call(severity, time, progname, msg)
        sev_number = AdventLogger::SEVS.index(severity)
        sev_colors = Severity::COLORS[sev_number]
        string = Format % [severity[0..0], time.strftime('%F %T '), $$, severity.center(SEV_MAX_LENGTH), progname, msg2str(msg)]
        highlights = string.scan(/\[([^\[\]]+)\]|`([^`]+)`/).flatten.reject(&:nil?)

        string.split(/[\[\]`]/).map { |sub_string|
          color = highlights.include?(sub_string) ? sev_colors[:highlight] : sev_colors[:default]
          sub_string = Rainbow(sub_string).fg(color)
          sub_string.background(sev_colors[:background]) if sev_colors[:background]
          sev_colors[:decorators]&.each { |decorator| sub_string = sub_string.send(decorator) }
          sub_string
        }.join
      end
    end

    @logger = AdventLogger.new(STDOUT, progname: 'AOC', formatter: Formatter.new)

    def level=(level)
      @logger.level = level
    end

  end

end

Engine::Logger = Engine::ColoredLogger
