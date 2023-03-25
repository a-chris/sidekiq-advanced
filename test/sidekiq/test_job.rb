# frozen_string_literal: true

require_relative "../test_helper"

class FakeJob
  include Sidekiq::Job
  include Sidekiq::Advanced::RecurrentJob

  set_advanced_options(keep_same_id: true)

  def perform(**args)
    puts args
  end
end

class AnotherFakeJob
  include Sidekiq::Job
  include Sidekiq::Advanced::RecurrentJob

  set_advanced_options(keep_same_id: false)

  def perform(**args)
    puts args
  end
end

class Sidekiq::TestAdvanced < Minitest::Test
  def setup
    Sidekiq.configure_server do |config|
      config.redis = { password: 'mimmo' }

      config.server_middleware do |chain|
        chain.add Sidekiq::Advanced::ServerMiddleware
      end
    end

    Sidekiq.configure_client do |config|
      config.redis = { password: 'mimmo' }

      config.client_middleware do |chain|
        chain.add Sidekiq::Advanced::ClientMiddleware
      end
    end
  end

  def test_options_not_collide
    assert_equal AnotherFakeJob.advanced_options.keep_same_id, false
    # assert_equal FakeJob.advanced_options.keep_same_id, true
  end

  def test_job_runs
    FakeJob.perform_inline
  end
end
