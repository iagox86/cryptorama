require 'bcrypt'
require 'digest'
require 'openssl'
require 'salsa20'
require 'smbhash'
require 'argon2'

module Cryptorama
  class Server < Sinatra::Base
    LEVEL6 = {
      name:   "Level 6: TODO",
      url:    "/level6",
      answer: 'lobster',
    }

    get '/level6' do
      message = nil
      error = nil

      erb :level6, :locals => {
        :completed => session[:level6][:completed],
        :message   => message,
        :error     => error,
      }
    end

    post '/level6' do
      if params[:answer].downcase == LEVEL6[:answer].downcase
        session[:level7][:open] = true
        session[:level6][:completed] = true

        erb :success, :locals => {
          :message => "Congratulations, you have completed level 6!",
        }
      else
        erb :failure, :locals => {
          :message => "Sorry, that answer is not correct!",
        }
      end
    end
  end
end
