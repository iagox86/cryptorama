# encoding: ASCII-8BIT

##
# Solve.rb
#
# Solution for Cryptorama Level 5 and 7
##

require './Poracle'
require 'httparty'
require 'singlogger'
require 'uri'

# Note: set this to DEBUG to get full full output
SingLogger.set_level_from_string(level: "DEBUG")
L = SingLogger.instance()

# 16 is good for AES and 8 for DES
BLOCKSIZE = 16

# Grab the data from the commandline, if they passed it
TOKEN = ARGV[0]
ENCRYPTED = ARGV[1]
NEW_DATA = ARGV[2]

if(ENCRYPTED.nil?)
  L.fatal("Usage: ruby Solve.rb <token> <encrypted hex data> [new data]")
  exit
end

# This is the do_decrypt block - you'll have to change it depending on what your
# service is expecting (eg, by adding cookies, making a POST request, etc)
poracle = Poracle.new(BLOCKSIZE) do |data|
  # If it's as simple as sticking hex in a URL, just change this to your new path
  base_url = "http://localhost:1234/level5?action=decrypt&token=#{TOKEN}&encrypted=#{ENCRYPTED}" # TODO

  # Just append our data to the base_url
  url = base_url + data.unpack('H*').pop()

  result = HTTParty.get(
    url,
  )

  # This is required for newer versions of Ruby sometimes
  result.parsed_response.force_encoding("ASCII-8BIT")

  # Split the response and find any line containing error / exception / fail
  # (case insensitive)
  errors = result.parsed_response.split(/\n/).select { |l| l =~ /(error|exception|fail)/i }

  #L.debug("Errors: %s" % errors.join(', '))

  # Return true if there are zero errors
  errors.empty?
end


L.info("Trying to decrypt: %s" % ENCRYPTED)

# Convert to a binary string using pack
data = [ENCRYPTED].pack("H*")

# Decrypt
result = poracle.decrypt_with_embedded_iv(data)

puts("-----------------------------")
puts("Decryption result")
puts("-----------------------------")
puts result
puts("-----------------------------")
puts()

if(NEW_DATA.nil?)
  exit
end

puts "Trying to encrypt: %s" % NEW_DATA
result = poracle.encrypt(NEW_DATA)

puts("-----------------------------")
puts("Encrypted string")
puts("-----------------------------")
puts result.unpack('H*')
puts("-----------------------------")
puts()
