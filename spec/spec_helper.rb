require 'bundler/setup'
Bundler.setup
require 'racked_react'
require 'rack/test'
require 'pry'

RSpec.configure do |config|
  config.color = true
  config.order = :random
  config.include Rack::Test::Methods
end

def app
  Rack::Builder.new do
    run RackedReact::Server.new('spec/example')
  end
end
