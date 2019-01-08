##
# server.rb
# By Ron
# 2019-01
#
# This implements a sinatra-based server.
##

require 'sinatra'
require 'sinatra/base'
require 'singlogger'
require 'securerandom'

require 'level1'
require 'level2'
require 'level3'
require 'level4'
require 'level5'
require 'level6'
require 'level7'

LOGGER = ::SingLogger.instance()

module Cryptorama
  class Server < Sinatra::Base
    enable :sessions

    def initialize(*args)
      super(*args)
    end

    configure do
      if(defined?(PARAMS))
        set :port, PARAMS[:port]
        set :bind, PARAMS[:host]
      end

      set :session_secret, ENV.fetch('SESSION_SECRET') {
				LOGGER.warn("No SESSION_SECRET found in ENV, using a random one")
				SecureRandom.hex(64)
			}
    end

    not_found do
      return 404, "Unknown path (make sure you're using get/post properly!)"
    end

    before do
      session[:level1] = { completed: false, show: true, open: true }.merge(session[:level1] || {})
      session[:level2] = { completed: false, show: true, open: true }.merge(session[:level2] || {})
      session[:level3] = { completed: false, show: true, open: true }.merge(session[:level3] || {})
      session[:level4] = { completed: false, show: true, open: true }.merge(session[:level4] || {})
      session[:level5] = { completed: false, show: true, open: true }.merge(session[:level5] || {})
      session[:level6] = { completed: false, show: true, open: true }.merge(session[:level6] || {})
      session[:level7] = { completed: false, show: true, open: true }.merge(session[:level7] || {})
    end

    get '/' do
      erb :index, :locals => {
        :levels => [
          LEVEL1.merge(session[:level1] || {}),
          LEVEL2.merge(session[:level2] || {}),
          LEVEL3.merge(session[:level3] || {}),
          LEVEL4.merge(session[:level4] || {}),
          LEVEL5.merge(session[:level5] || {}),
          LEVEL6.merge(session[:level6] || {}),
          LEVEL7.merge(session[:level7] || {}),
        ]
      }
    end
  end
end
