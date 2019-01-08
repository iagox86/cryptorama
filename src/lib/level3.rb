require 'openssl'
require 'salsa20'

def encrypt_aes_ecb(session, text)
  alg = "AES-256-ECB"

  if(session[:level3][:aes_key].nil?)
    session[:level3][:aes_key] = OpenSSL::Cipher::Cipher.new(alg).random_key
  end

  aes = OpenSSL::Cipher::Cipher.new(alg)
  aes.encrypt
  aes.key = session[:level3][:aes_key]

  # Now we go ahead and encrypt our plain text.
  return (aes.update(text) + aes.final).unpack("H*").pop
end

def decrypt_aes_ecb(session, ciphertext)
  alg = "AES-256-ECB"

  ciphertext = [ciphertext.gsub(/ /, '')].pack('H*')
  if(session[:level3][:aes_key].nil?)
    session[:level3][:aes_key] = OpenSSL::Cipher::Cipher.new(alg).random_key
  end

  aes = OpenSSL::Cipher::Cipher.new(alg)
  aes.decrypt
  aes.key = session[:level3][:aes_key]
  aes.padding = 0

  return (aes.update(ciphertext) + aes.final).bytes().map { |b| (b < 0x20 || b > 0x7F) ? '?'.ord : b }.pack('c*').gsub(/\?*$/, '')
end

def encrypt_salsa20(session, text)
  if(session[:level3][:salsa20_key].nil?)
    session[:level3][:salsa20_key] = OpenSSL::Cipher::Cipher.new('AES-256-ECB').random_key
  end

  encryptor = Salsa20.new(session[:level3][:salsa20_key], '-RANDOM-')
  return encryptor.encrypt(text).unpack('H*').pop
end

def decrypt_salsa20(session, ciphertext)
  ciphertext = [ciphertext.gsub(/ /, '')].pack('H*')
  if(session[:level3][:salsa20_key].nil?)
    session[:level3][:salsa20_key] = OpenSSL::Cipher::Cipher.new('AES-256-ECB').random_key
  end

  decryptor = Salsa20.new(session[:level3][:salsa20_key], '-RANDOM-')
  return decryptor.decrypt(ciphertext).bytes().map { |b| (b < 0x20 || b > 0x7F) ? '?'.ord : b }.pack('c*').gsub(/\?*$/, '')
end

module Cryptorama
  class Server < Sinatra::Base
    LEVEL3 = {
      name:   "Level 3: Change the encrypted text!",
      url:    "/level3",
      answer: 'evil_plan_why_not',
    }

    get '/level3' do
      messages = []
      errors = []

      if(params[:action] == 'decrypt_ecb')
        begin
          decrypted = decrypt_aes_ecb(session, params[:token])

          decrypted.split(',').each do |line|
            key, value = line.split('=', 2)
            if key
              params[key.to_sym] = value
            end
          end

          if(params[:is_admin] == '1')
            messages << "Congratulations, you are an admin! Dr. Z's secret site name is: <span class='highlight'>#{LEVEL3[:answer]}</span>"
          else
            errors << "Sorry, you aren't an admin! I decoded this block in AES-256-ECB:<br/><pre>#{ERB::Util.html_escape(decrypted)}</pre>"
          end
        rescue OpenSSL::Cipher::CipherError => e
          errors << "Problem decrypting your ciphertext: #{ERB::Util.html_escape(e.to_s)}"
        end
      end

      if(params[:action] == 'decrypt_salsa20')
          decrypted = decrypt_salsa20(session, params[:token])

          decrypted.split(',').each do |line|
            key, value = line.split('=', 2)
            if key
              params[key.to_sym] = value
            end
          end

          if(params[:is_admin] == '1')
            messages << "Salsa20: Congratulations, you are an admin! Dr. Z's secret site name is: <span class='highlight'>#{LEVEL3[:answer]}</span>"
          else
            errors << "Sorry, you aren't an admin! I decoded this block in Salsa20:<br/><pre>#{ERB::Util.html_escape(decrypted)}</pre>"
          end
      end

      first_name = params[:first_name] || 'Dr'
      last_name  = params[:last_name]  || 'Z'
      puts(first_name)

      cookie = "first_name=#{first_name},last_name=#{last_name},is_admin=0"

      erb :level3, :locals => {
        :completed => session[:level3][:completed],
        :messages  => messages,
        :errors    => errors,
        :first_name => ERB::Util.html_escape(first_name),
        :last_name => ERB::Util.html_escape(last_name),
        :ecb_token => encrypt_aes_ecb(session, cookie),
        :salsa20_token => encrypt_salsa20(session, cookie),
      }
    end

    post '/level3' do
      if params[:answer].downcase == LEVEL3[:answer].downcase
        session[:level4][:open] = true
        session[:level3][:completed] = true

        erb :success, :locals => {
          :message => "Congratulations, you have completed level 3!",
        }
      else
        erb :failure, :locals => {
          :message => "Sorry, that answer is not correct!",
        }
      end
    end
  end
end
