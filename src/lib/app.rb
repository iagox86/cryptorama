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

require 'level1'

module Cryptorama
  class Server < Sinatra::Base
    enable :sessions

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

    before do
      session[:test] = session[:test] || ''
    end

    get '/a' do
      session[:test] += 'a'
      return 200, "This is a! #{session[:test]}"
    end

    get '/b' do
      session[:test] += 'b'
      return 200, "This is b! #{session[:test]}"
    end

    get '/test' do
      erb :test
    end
  end
end
