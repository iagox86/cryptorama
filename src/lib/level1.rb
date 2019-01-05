module Cryptorama
  class Server < Sinatra::Base
    get '/c' do
      return 200, "omgz c worked!!"
    end
  end
end
