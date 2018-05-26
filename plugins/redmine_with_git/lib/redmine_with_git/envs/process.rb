module RedmineWithGit
  module Envs
    class Process
      def initialize(command)
        @command = command
        Open3.popen3(command) do |_stdin, stdout, stderr, wait_thr|
          with_threads(stdout, stderr, wait_thr)
        end
      end

      def to_h
        { exit_code: @exit_code, stdout: @stdout, stderr: @stderr, command: @command }
      end

      private

      def without_threads(stdout, stderr, wait_thr)
        @exit_code = wait_thr.value.to_i
        @stdout = stdout.read
        @stderr = stderr.read
      end

      def with_threads(stdout, stderr, wait_thr)
        threads = []
        threads << Thread.new { @exit_code = wait_thr.value.to_i }
        threads << Thread.new { @stdout = stdout.read }
        threads << Thread.new { @stderr = stderr.read }
        threads.each(&:join)
      end
    end
  end
end
