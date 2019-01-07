require 'json'

TEXT = {
  'signature'     => 'aabbccdd',
  'signature_alg' => 'sha256',
  'data'          => 'dGhpcyBpcyBhIHRlc3Q=',
  'test'          => 'test',
}

ALG = "AES-256-CBC"

class PaddingException < StandardError
end

def tohex(s)
  return s.unpack("H*").pop
end

def fromhex(s)
  return [s].pack("H*")
end

# Note: I'm using a token here that I'm including in the URL, for the purposes
# of not requiring a session (and therefore making this much easier to solve).
def reset()
  token = (1..8).map{rand(255).chr}.join
  iv    = (1..16).map{rand(255).chr}.join

  c = OpenSSL::Cipher::Cipher.new(ALG)
  c.encrypt
  c.key = token * 4
  c.iv  = iv

  return tohex(token), tohex(iv + c.update(TEXT.to_json()) + c.final)
end

def decrypt(token, data)
  c = OpenSSL::Cipher::Cipher.new(ALG)
  c.decrypt
  c.key = fromhex(token) * 4

  iv, data = fromhex(data).unpack("a16a*")
  c.iv = iv

  # Disable padding validation so we can do it manually
  c.padding = 0

  # Now we go ahead and encrypt our plain text.
  result = c.update(data) + c.final

  if(result.length == 0)
    raise(PaddingException, "At least one block is required!")
  end

  # Manually check the padding (so we can give a better error)
  last_byte = result[result.length - 1].ord

  # Make sure it's no more than a block
  if(last_byte > 0x10 || last_byte <= 0)
    raise(PaddingException, "Last byte of padding is illegal: 0x%02x!" % last_byte)
  end

  # Make sure it's not longer than the string
  if(last_byte > result.length)
    raise(PaddingException, "Padding is unexpectedly large: %d bytes!" % last_byte)
  end

  # Make sure the last n bytes are all n
  expected_padding = last_byte.chr * last_byte
  if(!result.end_with?(expected_padding))
    raise(PaddingException, "Padding is invalid (string doesn't end with the right sequence of bytes)!")
  end

  # Remove the padding
  return result.gsub(/#{expected_padding}$/, '')
end


module Cryptorama
  class Server < Sinatra::Base
    LEVEL5 = {
      name:   "Level 5: Padding Oracle",
      url:    "/level5",
      answer: 'TODO',
    }

    get '/level5' do
      message = nil
      error = nil

      action = params[:action]
      token = params[:token]
      encrypted = params[:encrypted]

      if(token.nil?)
        message = "New encryption key generated!"
        token, encrypted = reset()
      elsif(action == 'decrypt')
        # TODO: Don't display this
        begin
          message = decrypt(token, encrypted)
          message = "Data successfully decrypted and stored!"
        rescue PaddingException => e
          error = "ERROR: Data decryption failed: #{e}"
        end
      end


      erb :level5, :locals => {
        :completed => session[:level5][:completed],
        :message   => message,
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
