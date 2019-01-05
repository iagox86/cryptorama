module Cryptorama
  class Server < Sinatra::Base
    LEVEL1 = {
      name:   "Level 1: Encoding and decoding",
      url:    "/level1",
      answer: 'level2unlocked',
    }

    get '/level1' do
      erb :level1
    end

    post '/level1' do
      if params[:answer] == LEVEL1[:answer]
        session[:level2][:open] = true

        erb :success, :message => "Unlocked level 2!"
      else
        erb :failure, :message => "Sorry, that is incorrect!"
      end
    end
  end
end
