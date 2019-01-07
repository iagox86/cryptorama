require 'digest'
require 'json'

require 'scheme'

module Cryptorama
  class Server < Sinatra::Base
    LEVEL5 = {
      name:   "Level 5: Padding Oracle",
      url:    "/level5",
      answer: 'TODO',
    }

    get '/level5' do
      message = []
      error = nil

      action = params[:action]

      # Get the current token
      token, msg = get_token(params, session, params[:action] == 'reset')
      if(!msg.nil?)
        message << msg
      end

      # Get the encrypted text from either the parameters or newly generated
      encrypted = params[:encrypted] || session[:encrypted] || scheme_encrypt(token, scheme_reset(token))

      if(action == 'decrypt')
        begin
          scheme_decrypt(token, encrypted)
          message << "Data successfully decrypted and stored!"
        rescue PaddingException => e
          error = "ERROR: Data decryption failed: #{e}"
        end
      end

      erb :level5, :locals => {
        :completed => session[:level5][:completed],
        :message   => message.join("<br />"),
        :error     => error,

        :encrypted => ERB::Util.html_escape(encrypted),
        :token     => ERB::Util.html_escape(token),
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
