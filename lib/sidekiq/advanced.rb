# frozen_string_literal: true

require "sidekiq"

require_relative "advanced/version"
require_relative "advanced/server_middleware"
require_relative "advanced/client_middleware"
require_relative "advanced/options"
require_relative "advanced/recurrent_job"

module Sidekiq
  module Advanced
    class Error < StandardError; end
  end

  if Object.const_defined?('Sidekiq::JobUtil')
    module JobUtil
      alias_method :normalize_item_original, :normalize_item

      def normalize_item(item)
        item = normalize_item_original(item)
        if item['keep_same_id'] && item["jid"]
          item["jid"] = item["jid"].to_s
        end
        item
      end
    end
  end
end
