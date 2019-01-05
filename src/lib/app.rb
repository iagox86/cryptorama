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
require 'level2'
require 'level3'

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
      session[:level1] = { show: true,  open: true  }.merge(session[:level1] || {})
      session[:level2] = { show: true,  open: false }.merge(session[:level2] || {})
      session[:level3] = { show: false, open: false }.merge(session[:level3] || {})
      session[:level4] = { show: false, open: false }.merge(session[:level4] || {})
      session[:level5] = { show: false, open: false }.merge(session[:level5] || {})
      session[:level6] = { show: false, open: false }.merge(session[:level6] || {})
      session[:level7] = { show: false, open: false }.merge(session[:level7] || {})
      session[:level8] = { show: false, open: false }.merge(session[:level8] || {})
      session[:level9] = { show: false, open: false }.merge(session[:level9] || {})
    end

    get '/' do
      puts session.keys
      erb :index, :locals => {
        :levels => [
          LEVEL1.merge(session[:level1] || {}),
          LEVEL2.merge(session[:level2] || {}),
          LEVEL3.merge(session[:level3] || {}),
        ]
      }
    end
  end
end
