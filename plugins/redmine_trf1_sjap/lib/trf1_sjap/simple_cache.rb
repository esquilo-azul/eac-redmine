module Trf1Sjap
  module SimpleCache
    def cache_value(key, &block)
      fail 'Bloco não passado' unless block_given?
      cache_keys[key] = block.call unless cache_keys.key?(key)
      cache_keys[key]
    end

    def reset_cache
      @cache_keys = nil
    end

    private

    def cache_keys
      @cache_keys ||= {}
    end
  end
end
