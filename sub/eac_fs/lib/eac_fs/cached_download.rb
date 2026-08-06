# frozen_string_literal: true

require 'open-uri'

module EacFs
  class CachedDownload
    attr_reader :url, :fs_cache

    def initialize(url, parent_fs_cache = nil)
      @url = url
      @fs_cache = (parent_fs_cache || fs_cache).child(url.to_s.parameterize)
    end

    def assert
      download unless fs_cache.stored?
    end

    def download
      ::EacRubyUtils::Fs::Temp.on_file do |temp|
        download_to(temp)
        fs_cache.content_path.to_pathname.dirname.mkpath
        ::FileUtils.mv(temp.to_path, fs_cache.content_path)
      end
    end

    def path
      fs_cache.content_path.to_pathname
    end

    private

    def download_to(local_file)
      ::URI.parse(url).open do |remote|
        local_file.open('wb') { |handle| handle.write(remote.read) }
      end
    end
  end
end
