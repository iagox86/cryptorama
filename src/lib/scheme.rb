# encoding: ASCII-8BIT

require 'base64'
require 'openssl'

ALG = "AES-256-CBC"
TOKEN_LENGTH = 8

class PaddingException < StandardError
end

def _to_hex(s)
  return s.unpack("H*").pop
end

def _from_hex(s)
  return [s].pack("H*")
end

# Just repeat the token to make it long enough
def _crypto_key(token)
  return _from_hex(token) * (32 / TOKEN_LENGTH)
end

# Just needs to be good enough to prevent casual guessing
def _signing_key(token)
  return token.reverse.upcase
end

def _gen_token(session)
  session[:token] = _to_hex((1..TOKEN_LENGTH).map{rand(255).chr}.join)
  return session[:token]
end

def get_token(params, session, reset=false)
  # If a reset was requested, just do it
  if(reset)
    return _gen_token(session), "Generating a new token (reset requested)"
  end

  # If it's in the params, store that in the session and use it
  if(params[:token] && params[:token].length == (TOKEN_LENGTH * 2))
    session[:token] = params[:token]
    return params[:token], "Using token from GET arguments"
  end

  # If it's not in the params, grab it from the session
  if(session[:token] && session[:token].length == (TOKEN_LENGTH * 2))
    return session[:token], "Using token from session"
  end

  # If it's nowhere else, just generate it
  return _gen_token(session), "Couldn't find a token: generating a new one"
end

# Note: I'm using a token here that I'm including in the URL, for the purposes
# of not requiring a session (and therefore making this much easier to solve).
def scheme_reset(token)
  script = [
    "1. Steal the professor's package",
    "2. Hide it somewhere he'll never think to look",
    "3. ???",
    "4. Profit!",
  ].join("\n")

  signing_key = _signing_key(token)
  return {
    'codename'      => 'money_making_scheme',
    'signature_alg' => 'sha256',
    'script'        => Base64.strict_encode64(script),
    'secret_length' => signing_key.length,

    # Just lightly obfuscate the token so we can re-use it for this
    'signature'     => Digest::SHA256.hexdigest(signing_key + script),
  }
end

def scheme_encrypt(token, scheme)
  # Pick a random IV - it doesn't really matter
  iv = (1..16).map{rand(255).chr}.join

  c = OpenSSL::Cipher::Cipher.new(ALG)
  c.encrypt
  c.key = _crypto_key(token)
  c.iv  = iv

  return _to_hex(iv + c.update(scheme.to_json()) + c.final)
end

def scheme_decrypt(token, data)
  c = OpenSSL::Cipher::Cipher.new(ALG)
  c.decrypt
  c.key = _crypto_key(token)

  iv, data = _from_hex(data).unpack("a16a*")
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

def scheme_verify(token, scheme)
  script = scheme['script']
  if(script.nil?)
    raise(ArgumentError, "Missing 'script' parameter!")
  end

  script = Base64.decode64(script)

  puts("ALG: ")
  puts(scheme.to_json)
  if(scheme['signature_alg'] != "sha256")
    raise(ArgumentError, "Sorry, the algorithm can't be changed, but good thought!")
  end
  if(scheme['secret_length'] != 16)
    raise(ArgumentError, "Sorry, the secret length can't be changed, but good thought!")
  end

  # TODO: Verify
  signing_key = _signing_key(token)
  signature   = Digest::SHA256.hexdigest(signing_key + script)

  if(signature != scheme['signature'])
    raise(ArgumentError, "Signature didn't match!")
  end

  return script
end

def scheme_decrypt_verify(token, data)
  decrypted = scheme_decrypt(token, data)
  decrypted = decrypted.force_encoding('ASCII-8BIT')
  puts(decrypted)
  decrypted = JSON.parse(decrypted)

  return scheme_verify(token, decrypted)
end
