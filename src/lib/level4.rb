require 'bcrypt'
require 'digest'
require 'openssl'
require 'salsa20'
require 'smbhash'
require 'argon2'

def hash_crypt(pw)
  salt = (0...8).map { '0123456789abcdef'.chars.sample }.join
  return pw.crypt(salt)
end

def hash_lanman(pw)
  return Smbhash.lm_hash(pw)
end

def hash_ntlm(pw)
  return Smbhash.ntlm_hash(pw)
end

def hash_mediawiki(pw)
  # md5($s.'-'.md5($p))
  salt = (0...8).map { '0123456789abcdef'.chars.sample }.join
  return "$B$%s$%s" % [salt, Digest::MD5.hexdigest(salt + '-' + Digest::MD5.hexdigest(pw))]
end

def hash_bcrypt(pw, cost)
  BCrypt::Engine.cost = cost
  return BCrypt::Password.create(pw)
end

def hash_argon2(pw)
  return Argon2::Password.create(pw)
end

module Cryptorama
  class Server < Sinatra::Base
    LEVEL4 = {
      name:   "Level 4: Password cracking",
      url:    "/level4",
      answer: 'lobster',
    }

    get '/level4' do
      message = nil
      error = nil

      erb :level4, :locals => {
        :completed => session[:level4][:completed],
        :message   => message,
        :error     => error,
      }
    end

    post '/level4' do
      if params[:answer].downcase == LEVEL4[:answer].downcase
        session[:level5][:open] = true
        session[:level4][:completed] = true

        erb :success, :locals => {
          :message => "Congratulations, you have completed level 4!",
        }
      else
        erb :failure, :locals => {
          :message => "Sorry, that answer is not correct!",
        }
      end
    end
  end
end
