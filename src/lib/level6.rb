require 'json'
require 'scheme'

module Cryptorama
  class Server < Sinatra::Base
    LEVEL6 = {
      name:   "Level 6: Hash extension",
      url:    "/level6",
      answer: 'were_almost_there_now',
      codeword: '5. Give back the package',
    }

    get '/level6' do
      message = []
      error = nil

      action = params[:action]

      # Get the current token
      token, msg = get_token(params, session, params[:action] == 'reset')
      if(!msg.nil?)
        message << msg
      end

      # Get the encrypted text from either the parameters or newly generated
      raw_data = params[:signed] || session[:signed] || JSON.pretty_generate(scheme_reset(token))

      begin
        scheme = JSON.parse(raw_data)

        if(action == 'validate')
          script = scheme_verify(token, scheme)
          message << "Data successfully decoded and verified!"

          if(script.index(LEVEL6[:codeword]))
            message << "Verified the new step! Great work! Enter code <span class='highlight'>#{LEVEL6[:answer]}</span> to continue!"
          else
            message << "Data doesn't contain the new step yet!"
          end
        end

        raw_data = JSON.pretty_generate(scheme)
      rescue JSON::ParserError => e
        error = "Error parsing the JSON: #{e}"
      rescue ArgumentError => e
        error = "Error decoding data: #{e}"
      end

      erb :level6, :locals => {
        :completed => session[:level6][:completed],
        :message   => message.join("<br />"),
        :error     => error,

        :token     => token,
        :signed    => raw_data,
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
