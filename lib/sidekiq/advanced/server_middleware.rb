module Sidekiq
  module Advanced
    class ServerMiddleware
      include Sidekiq::ServerMiddleware

      def call(_worker, job, _queue)
        execution_result = yield

        # `wrapped` field used by ActiveJob, `class` by Sidekiq::Job
        job_class = Object.const_get(job["wrapped"] || job["class"])

        begin
          if job_class.respond_to?(:save_execution)
            job_class.save_execution(execution_result)
          end
        rescue StandardError => e
          Sidekiq.logger.error("Error while saving job execution: #{e.message}")
        end

        begin
          if job_class < RecurrentJob
            # reschedule job at its calculated next_run_at
            next_at = job_class.calculate_next_run_at(execution_result)
            job["at"] = next_at.utc.to_i
            Sidekiq::Client.push(job)
          end
        rescue => e
          Sidekiq.logger.error("Error while rescheduling job: #{e.message}")
        end

        execution_result
      rescue StandardError => e
        Sidekiq.logger.error("Error in Sidekiq::Advanced::ServerMiddleware: #{e.message}")
      end
    end
  end
end
