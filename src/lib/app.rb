##
# server.rb
# By Ron
# 2019-01
#
# This implements a sinatra-based server.
##

#require 'json'
#require 'securerandom'
require 'sinatra'
require 'sinatra/base'

require 'singlogger'

module Cryptorama
  class Server < Sinatra::Base
    def initialize(*args)
      super(*args)

      @logger = ::SingLogger.instance()
    end

    configure do
      if(defined?(PARAMS))
        set :port, PARAMS[:port]
        set :bind, PARAMS[:host]
      end
    end

    not_found do
      return 404, "Unknown path (make sure you're using get/post properly!)"
    end

    get '/a' do
      return 200, 'This is a!'
    end

    get '/b' do
      return 200, 'This is b!'
    end

  end
end
