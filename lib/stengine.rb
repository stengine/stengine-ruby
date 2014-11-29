require "stengine/version"
require 'httparty'

module Stengine
	class Configuration
		attr_accessor :api_token

		def initialize
		  self.api_token = nil
		end
	end

	class API
		include HTTParty
		base_uri 'http://api.stengine.io'
	end

	def self.configuration
	  @configuration ||=  Configuration.new
	end

	def self.configure
	  yield(configuration) if block_given?
	end

	def self.api_token
		throw "Stengine's API Token was not found." if self.configuration.api_token.nil?
		return self.configuration.api_token
	end

	def self.event(event_name, model)
		token = self.api_token
		Thread.new{
			API.post("/events", body: {
				name: event_name,
				model: model,
				token: token
			})
		}
	end
	# class Stengine
		
	# end
end