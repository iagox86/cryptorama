require 'json'

TEXT = {
  'signature'     => 'aabbccdd',
  'signature_alg' => 'sha256',
  'data'          => 'dGhpcyBpcyBhIHRlc3Q='
}

def reset(session)
  alg = "AES-256-CBC"
  data = TEXT.to_json()

  session[:level5][:key] = OpenSSL::Cipher::Cipher.new(alg).random_key
  session[:level5][:iv]  = OpenSSL::Cipher::Cipher.new(alg).random_iv

  aes = OpenSSL::Cipher::Cipher.new(alg)
  aes.encrypt
  aes.key = session[:level5][:key]
  aes.iv  = session[:level5][:iv]

  # Now we go ahead and encrypt our plain text.
  session[:level5][:encrypted] = (aes.update(data) + aes.final).unpack("H*").pop
end

def decrypt(session, data)
  alg = "AES-256-CBC"

  aes = OpenSSL::Cipher::Cipher.new(alg)
  aes.decrypt
  aes.key = session[:level5][:key]
  aes.iv  = session[:level5][:iv]
  aes.padding = 0

  # Now we go ahead and encrypt our plain text.
  return aes.update([data].pack("H*")) + aes.final
end

module Cryptorama
  class Server < Sinatra::Base
    LEVEL5 = {
      name:   "Level 5: TODO",
      url:    "/level5",
      answer: 'TODO',
    }

    get '/level5' do
      message = nil
      error = nil

      if(session[:level5][:encrypted].nil?)
        reset(session)
      end

      if(params[:action] == 'reset')
        reset(session)
      elsif(params[:action] == 'decrypt')
        begin
          # TODO: Don't display this
          message = decrypt(session, params[:encrypted])
          message = message + " :: " + message.unpack("H*").to_s
        rescue OpenSSL::Cipher::CipherError => e
          error = "Could not decrypt: " + e.to_s
        end
      end

      erb :level5, :locals => {
        :completed => session[:level5][:completed],
        :message   => message,
        :error     => error,

        :encrypted => session[:level5][:encrypted]
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
