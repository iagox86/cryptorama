module Cryptorama
  class Server < Sinatra::Base
    LEVEL2 = {
      name:   "Level 2: PRNG Guessing",
      url:    "/level2",
      answer: 'level3isnextnow',
    }

    get '/level2' do
      erb :level2
    end

    post '/level2' do
      if params[:answer] == LEVEL2[:answer]
        # TODO: Unlock level 3
        erb :success, :message => "Unlocked level 3!"
      else
        erb :failure, :message => "Sorry, that is incorrect!"
      end
    end
  end
end
