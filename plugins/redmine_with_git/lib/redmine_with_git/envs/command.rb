require 'open3'
require 'pp'

module RedmineWithGit
  module Envs
    class Command
      def initialize(env, command)
        @env = env
        if command.count == 1 && command.first.is_a?(Array)
          @command = command.first
        elsif command.is_a?(Array)
          @command = command
        else
          fail "Invalid argument command: #{command}|#{command.class}"
        end
      end

      def append(args)
        self.class.new(@env, @command + args)
      end

      def prepend(args)
        self.class.new(@env, args + @command)
      end

      def to_s
        "#{@command} [ENV: #{@env}]"
      end

      def command(options = {})
        c = @command
        c = c.map { |x| escape(x) }.join(' ') if c.is_a?(Enumerable)
        c = @env.command_line(c)
        append_command_options(c, options)
      end

      def execute!(options = {})
        er = ExecuteResult.new(execute(options), options)
        return er.result if er.success?
        fail "execute! command failed: #{self}\n#{er.r.pretty_inspect}"
      end

      def execute(options = {})
        c = command(options)
        puts "BEFORE: #{c}" if debug?
        t1 = Time.zone.now
        r = ::RedmineWithGit::Envs::Process.new(c).to_h
        i = Time.zone.now - t1
        puts "AFTER [#{i}]: #{c}" if debug?
        r
      end

      def system!(options = {})
        return if system(options)
        fail "system! command failed: #{self}"
      end

      def system(options = {})
        c = command(options)
        puts c if debug?
        Kernel.system(c)
      end

      private

      def append_command_options(c, options)
        c = options[:input].command + ' | ' + c if options[:input]
        c = "cat #{Shellwords.escape(options[:input_file])} | #{c}" if options[:input_file]
        c += ' > ' + Shellwords.escape(options[:output_file]) if options[:output_file]
        c
      end

      def escape(s)
        s = s.to_s
        m = /^\@ESC_(.+)$/.match(s)
        m ? m[1] : Shellwords.escape(s)
      end

      def debug?
        ENV['DEBUG'].present?
      end

      class ExecuteResult
        attr_reader :r, :options

        def initialize(r, options)
          @r = r
          @options = options
        end

        def result
          return exit_code_zero_result if exit_code_zero?
          return expected_error_result if expected_error?
          fail 'Failed!'
        end

        def success?
          exit_code_zero? || expected_error?
        end

        private

        def exit_code_zero?
          r[:exit_code] && r[:exit_code].zero?
        end

        def exit_code_zero_result
          r[options[:output] || :stdout]
        end

        def expected_error_result
          options[:exit_outputs][r[:exit_code]]
        end

        def expected_error?
          options[:exit_outputs].is_a?(Hash) && options[:exit_outputs].key?(r[:exit_code])
        end
      end
    end
  end
end
