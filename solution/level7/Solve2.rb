# encoding: ASCII-8BIT

##
# Solve2.rb
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
NEW_JSON = ARGV[1]

if(NEW_JSON.nil?)
  L.fatal("Usage: ruby Solve2.rb <token> <new json>")
  exit
end

# This is the do_decrypt block - you'll have to change it depending on what your
# service is expecting (eg, by adding cookies, making a POST request, etc)
poracle = Poracle.new(BLOCKSIZE) do |data|
  # If it's as simple as sticking hex in a URL, just change this to your new path
  base_url = "http://localhost:1234/level7?action=decrypt&token=#{TOKEN}&encrypted=" # TODO

  # Just append our data to the base_url
  url = base_url + data.unpack('H*').pop()

  # Print it
  #L.debug(url)

  result = HTTParty.get(
    url,
  )

  # This is required for newer versions of Ruby sometimes
  result.parsed_response.force_encoding("ASCII-8BIT")

  # Split the response and find any line containing error / exception / fail
  # (case insensitive)
  errors = result.parsed_response.split(/\n/).select { |l| l =~ /(error|exception|fail)/i }

  #L.debug("Errors: %s" % errors.join(', '))

  #puts(errors)

  # Return true if there are zero errors
  errors.empty?
end

L.info("Trying to encrypt: %s" % NEW_JSON)

# Encrypt
result = poracle.encrypt(NEW_JSON)

puts("-----------------------------")
puts("Encryption result")
puts("-----------------------------")
puts result.unpack('H*')
puts("-----------------------------")
puts()
