def fakerand(session, max)
  if session[:level2][:seed].nil?
    session[:level2][:seed] = rand(0x00FFFFFF)
  end

  session[:level2][:seed] = (session[:level2][:seed] * 214013 + 2531011) % 0x00FFFFFF

  return session[:level2][:seed] % max
end

def gen_password(session)
  p = ''
  0.upto(11) do
    p += '%02x' % fakerand(session, 256)
  end

  return p
end

module Cryptorama
  class Server < Sinatra::Base
    LEVEL2 = {
      name:   "Level 2: Guess the password!",
      url:    "/level2",
      answer: 'poor_unprivileged_guest',
    }

    get '/level2' do
      message = nil
      error = nil

      # Make sure an initial password is set
      if(session[:level2][:password].nil?)
        session[:level2][:password] = gen_password(session)
      end

      # Reset / display a fake password
      if(params[:action] == 'reset')
        # Generate one
        my_password = gen_password(session)

        # Generate the next
        session[:level2][:password] = gen_password(session)

        message = "You reset your test password to #{my_password}<br/>Dr. Z's password is set to the following!<br/>Good luck!"
      elsif(params[:action] == 'login')
        if(params[:password] == session[:level2][:password])
          message = "Congratulations! You're now logged in as <span class='highlight'>#{LEVEL2[:answer]}</span>! (Copy that into the answer box)"
        else
          error = "Sorry, that password is incorrect!"
        end
      end

      erb :level2, :locals => {
        :completed => session[:level2][:completed],
        :message   => message,
        :error     => error,
      }
    end

    post '/level2' do
      if params[:answer].downcase == LEVEL2[:answer].downcase
        session[:level3][:open] = true
        session[:level2][:completed] = true

        erb :success, :locals => {
          :message => "Congratulations, you have completed level 2!",
        }
      else
        erb :failure, :locals => {
          :message => "Sorry, that answer is not correct!",
        }
      end
    end
  end
end
