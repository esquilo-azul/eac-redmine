# frozen_string_literal: true

module Avm
  module Instances
    module EntryKeys
      URI_FIELDS = ::Avm::Entries::UriBuilder::ENTRIES_FIELDS + %w[url]

      class << self
        def all
          all_keys.to_a
        end

        def keys_consts_set(prefix, suffixes)
          all_keys.merge(::Avm::Entries::KeysConstantsSet.new(self, prefix, suffixes).result)
        end

        private

        def all_keys
          @all_keys ||= ::Set.new
        end
      end

      {
        '' => %w[name source_instance_id],
        admin: URI_FIELDS + %w[api_key],
        data: %w[allow_loading default_dump_path],
        database: URI_FIELDS + %w[id limit name system timeout extra],
        docker: %w[registry],
        install: URI_FIELDS + %w[id data_path email groupname],
        mailer: {
          '' => %w[id from reply_to],
          smtp: URI_FIELDS + %w[address domain authentication openssl_verify_mode starttls_auto tls]
        },
        web: URI_FIELDS
      }.each { |prefix, suffixes| keys_consts_set(prefix, suffixes) }
    end
  end
end
