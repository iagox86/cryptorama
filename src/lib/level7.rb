module Cryptorama
  class Server < Sinatra::Base
    LEVEL7 = {
      name:   "Level 7: TODO",
      url:    "/level7",
      answer: 'TODO',
    }

    get '/level7' do
      message = nil
      error = nil

      erb :level7, :locals => {
        :completed => session[:level7][:completed],
        :message   => message,
        :error     => error,
      }
    end

    post '/level7' do
      if params[:answer].downcase == LEVEL7[:answer].downcase
        session[:level7][:completed] = true

        erb :success, :locals => {
          :message => "Congratulations, you have completed the final level!",
        }
      else
        erb :failure, :locals => {
          :message => "Sorry, that answer is not correct!",
        }
      end
    end
  end
end
