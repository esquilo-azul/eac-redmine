module RedmineWithGit
  module Envs
    class BaseEnv
      def command(*args)
        RedmineWithGit::Envs::Command.new(self, args)
      end

      def file_exist?(file)
        command(['stat', file]).execute[:exit_code].zero?
      end
    end
  end
end
