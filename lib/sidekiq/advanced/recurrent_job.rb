module Sidekiq
  module Advanced
    module RecurrentJob
      def self.included(klass)
        klass.extend(ClassMethods)
      end

      module ClassMethods
        @advanced_options = Options.from_hash({})

        def calculate_next_run_at(execution)
          # TODO
        end

        def save_execution(execution)
          # TODO
        end

        def set_advanced_options(value)
          @advanced_options = Options.from_hash(**value)
        end

        def advanced_options
          @advanced_options
        end
      end
    end
  end
end
