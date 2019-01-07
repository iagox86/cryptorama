require 'bcrypt'
require 'digest'
require 'openssl'
require 'salsa20'
require 'smbhash'
require 'argon2'

module Cryptorama
  class Server < Sinatra::Base
    LEVEL5 = {
      name:   "Level 5: TODO",
      url:    "/level5",
      answer: 'lobster',
    }

    get '/level5' do
      message = nil
      error = nil

      erb :level5, :locals => {
        :completed => session[:level5][:completed],
        :message   => message,
        :error     => error,
      }
    end

    post '/level5' do
      if params[:answer].downcase == LEVEL5[:answer].downcase
        session[:level6][:open] = true
        session[:level5][:completed] = true

        erb :success, :locals => {
          :message => "Congratulations, you have completed level 5!",
        }
      else
        erb :failure, :locals => {
          :message => "Sorry, that answer is not correct!",
        }
      end
    end
  end
end
