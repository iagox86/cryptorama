module Cryptorama
  class Server < Sinatra::Base
    LEVEL3 = {
      name:   "Level 3: Password cracking",
      url:    "/level3",
      answer: 'level4somethingsomething',
    }

    get '/level3' do
      erb :level3
    end

    post '/level3' do
      if params[:answer] == LEVEL3[:answer]
        # TODO: Unlock level 4
        erb :success, :message => "Unlocked level 4!"
      else
        erb :failure, :message => "Sorry, that is incorrect!"
      end
    end
  end
end
