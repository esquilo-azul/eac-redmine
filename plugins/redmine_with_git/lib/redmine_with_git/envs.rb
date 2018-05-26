module RedmineWithGit
  module Envs
    class << self
      def local
        @local ||= RedmineWithGit::Envs::LocalEnv.new
      end
    end
  end
end
