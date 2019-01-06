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

    # TODO: Only open the first one
    before do
      session[:level1] = { completed: false, show: true,  open: true  }.merge(session[:level1] || {})
      session[:level2] = { completed: false, show: true,  open: true }.merge(session[:level2] || {})
      session[:level3] = { completed: false, show: false, open: true }.merge(session[:level3] || {})
      session[:level4] = { completed: false, show: false, open: true }.merge(session[:level4] || {})
      session[:level5] = { completed: false, show: false, open: true }.merge(session[:level5] || {})
      session[:level6] = { completed: false, show: false, open: true }.merge(session[:level6] || {})
      session[:level7] = { completed: false, show: false, open: true }.merge(session[:level7] || {})
      session[:level8] = { completed: false, show: false, open: true }.merge(session[:level8] || {})
      session[:level9] = { completed: false, show: false, open: true }.merge(session[:level9] || {})
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
