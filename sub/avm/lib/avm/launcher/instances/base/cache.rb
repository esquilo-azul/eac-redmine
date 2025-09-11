# frozen_string_literal: true

module Avm
  module Launcher
    module Instances
      module Base
        module Cache
          def cache_path(subpath)
            File.join(cache_root, subpath)
          end

          def cache_key(key, &block)
            v = cache_key_get(key)
            return v if v.present? || block.nil?

            v = yield
            cache_key_write(key, v)
            v
          end

          private

          def cache_key_get(key)
            File.file?(cache_key_path(key)) ? File.read(cache_key_path(key)) : nil
          end

          def cache_key_write(key, value)
            FileUtils.mkdir_p(File.dirname(cache_key_path(key)))
            File.write(cache_key_path(key), value)
          end

          def cache_key_path(key)
            File.join(cache_root, 'keys', key.parameterize)
          end

          def cache_root
            File.join(::Avm::Launcher::Context.current.cache_root, name.parameterize)
          end
        end
      end
    end
  end
end
