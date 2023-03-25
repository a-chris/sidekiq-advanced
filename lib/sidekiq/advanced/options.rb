module Sidekiq
  module Advanced
    class Options
      attr_reader :keep_same_id

      def initialize(keep_same_id:)
        @keep_same_id = keep_same_id
      end

      def self.from_hash(hash)
        keep_same_id = hash['keep_same_id'] || false
        new(keep_same_id: keep_same_id)
      end
    end
  end
end
