# frozen_string_literal: true

module Avm
  module Sources
    module AutoCommit
      class ForFile
        common_constructor :source, :path, :rules

        delegate :run, to: :scm_auto_commit

        # @return [Pathname]
        def path_for_auto_commit
          path.relative_path_from(source_for_auto_commit.path)
        end

        # @return [Avm::Scms::AutoCommit::ForFile]
        def scm_auto_commit
          ::Avm::Scms::AutoCommit::ForFile.new(source_for_auto_commit.scm, path_for_auto_commit,
                                               rules)
        end

        # @return [Avm::Sources::Base]
        def source_for_auto_commit
          source.sub_for_path(path) || source
        end
      end
    end
  end
end
