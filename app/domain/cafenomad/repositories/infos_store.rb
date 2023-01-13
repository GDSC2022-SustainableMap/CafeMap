# frozen_string_literal: true

# Background worker does clustering, no idea how to connect it yet
module CafeMap
  module Repository
    # Collection of all local git repo clones
    class InfoStore
      def self.all
        Dir.glob("#{App.config.REPOSTORE_PATH}/*")
      end

      def self.wipe
        all.each { |dir| FileUtils.rm_r(dir) }
      end
    end
  end
end
