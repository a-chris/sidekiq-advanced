# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "sidekiq/advanced"

require "minitest/autorun"

require "byebug"
