# Base32 / Base64 / Hex / binary / urlencode / ascii (decimal) etc
require 'base64'
require 'base32'

def base64(text)
  return Base64.encode64(text)
end

def hex(text)
  return text.unpack("H*")[0].gsub(/(..)/, '\1 ')
end

def binary(text)
  return text.unpack('B*')[0].gsub(/(........)/, '\1 ')
end

def urlenc(text)
  return text
end

def ascii(text)
  return text.bytes().join(" ")
end

def base32(text)
  return Base32.encode(text).downcase
end

def everything(text)
  return hex(ascii(urlenc(base32(base64(text)))))
end

module Cryptorama
  class Server < Sinatra::Base
    LEVEL1 = {
      name:   "Level 1: The package thief!",
      url:    "/level1",
      answer: 'Dr.Z',
    }

    get '/level1' do
      message = nil
      error = nil

      erb :level1, :locals => {
        :completed => session[:level1][:completed],
        :message   => message,
        :error     => error,
      }
    end

    post '/level1' do
      if params[:answer].downcase == LEVEL1[:answer].downcase
        session[:level2][:open] = true
        session[:level1][:completed] = true

        erb :success, :locals => {
          :message => "Congratulations, you have completed level 1!",
        }
      else
        erb :failure, :locals => {
          :message => "Sorry, that answer is not correct!",
        }
      end
    end
  end
end
