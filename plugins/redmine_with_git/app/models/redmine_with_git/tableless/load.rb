# frozen_string_literal: true

module RedmineWithGit
  module Tableless
    class Load < ::EacRailsUtils::Models::Tableless
      attribute :path, String

      validates :path, presence: true

      def save
        return false unless valid?

        ::RedmineWithGit::Load::All.new(path.path)
        true
      rescue StandardError => e
        errors.add(:path, e.message)
        false
      end

      def path_path
        path.is_a?(Pathname) ? path.path : path.to_s
      end
    end
  end
end
