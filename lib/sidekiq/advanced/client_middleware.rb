module Sidekiq
  module Advanced
    class ClientMiddleware
      include Sidekiq::ClientMiddleware

      # def initialize
      #   Sidekiq::JobUtil.alias_method(:normalize_item_original, :normalize_item)
      #   Sidekiq::JobUtil.define_method(:normalize_item) do |item|
      #     item = normalize_item_original(item)
      #     if item['keep_same_id'] && item["jid"]
      #       item["jid"] = item["jid"].to_s
      #     end
      #     item
      #   end
      # end

      def call(worker, job, queue, redis_pool)
        begin
          job_class = Object.const_get(job["wrapped"] || job["class"])
          if job_class < RecurrentJob
            job['keep_same_id'] = job_class.advanced_options.keep_same_id
          end
        rescue StandardError => e
          Sidekiq.logger.error("Error in Sidekiq::Advanced::ClientMiddleware: #{e.message}")
        end

        yield
      end
    end
  end
end
