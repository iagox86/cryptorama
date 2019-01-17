# encoding: ASCII-8BIT

module Cryptorama
  class Server < Sinatra::Base
    LEVEL7 = {
      name:   "Level 7: Padding Oracle + Hash Extension",
      url:    "/level7",
      answer: 'good_news_everyone_we_did_it',
      codeword: LEVEL6[:codeword],
    }

    get '/level7' do
      messages = []
      errors = []
      reset = params[:action] == 'reset'

      action = params[:action]

      # Get the current token
      token, msg = get_token(params, session, reset)
      if(!msg.nil?)
        messages << msg
      end

      # Get the encrypted text from either the parameters or newly generated
      if(reset)
        messages << "Encrypting the message with a new key"
        encrypted = scheme_encrypt(token, scheme_reset(token, true))
      else
        encrypted = params[:encrypted] || session[:encrypted] || scheme_encrypt(token, scheme_reset(token, true))
      end

      if(action == 'decrypt')
        begin
          script = scheme_decrypt_verify(token, encrypted)
          messages << "Data successfully decrypted and stored!"

          if(script.index(LEVEL7[:codeword]))
            messages << "And verified the new step is present! Great work! Enter code <span class='highlight'>#{LEVEL7[:answer]}</span> to continue!"
          else
            messages << "Data doesn't contain the new step yet!"
          end
        rescue PaddingException => e
          errors << "ERROR: Data decryption failed: #{e}"
        rescue JSON::ParserError => e
          errors << "JSON problem: #{e}"
        rescue ArgumentError => e
          errors << "Decoding problem: #{e}"
        end
      end

      erb :level7, :locals => {
        :completed => session[:level7][:completed],
        :messages  => messages,
        :errors    => errors,

        :encrypted => ERB::Util.html_escape(encrypted),
        :token     => ERB::Util.html_escape(token),
      }
    end

    post '/level7' do
      if params[:answer].downcase == LEVEL7[:answer].downcase
        session[:level7][:completed] = true

        erb :success, :locals => {
          :message => "Congratulations, you have completed the final level!",
        }
      else
        erb :failure, :locals => {
          :message => "Sorry, that answer is not correct!",
        }
      end
    end
  end
end
