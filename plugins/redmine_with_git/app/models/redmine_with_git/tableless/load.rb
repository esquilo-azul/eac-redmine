module RedmineWithGit
  module Tableless
    class Load < ::RedmineSjap::TablelessModel
      attribute :path, String

      def save
        ::RedmineWithGit::Load::All.new(path.path)
        true
      rescue StandardError => ex
        errors.add(:path, ex.message)
        false
      end
    end
  end
end
