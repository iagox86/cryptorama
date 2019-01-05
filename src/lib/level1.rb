module Cryptorama
  class Server < Sinatra::Base
    LEVEL1 = {
      name:   "Level 1: Encoding and decoding",
      url:    "/level1",
      answer: 'level2unlocked',
    }

    get '/level1' do
      erb :level1, :locals => {
        :completed => session[:level1][:completed]
      }
    end

    post '/level1' do
      if params[:answer] == LEVEL1[:answer]
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
