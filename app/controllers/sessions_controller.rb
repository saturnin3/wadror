class SessionsController < ApplicationController
  def new
     #renderöi kirjautumissivun
  end

  def create
    #haetaan usernamea vastaava käyttäjä tietokannasta
    user = User.find_by username: params[:username]
    if user && user.authenticate(params[:password])
      if user.suspended
        redirect_to :back, notice: "Your account is frozen, please contact admin"
      else
        #tallennetaan sessioon kirjautuneen käyttäjän id (jos olemassa)
        session[:user_id] = user.id
        #uudelleenohjataan käyttäjä omalle sivulleen
        redirect_to user, notice: "Welcome back!"
      end
    else
      redirect_to :back, notice: "Username and/or password mismatch"
    end
  end

  def destroy
    #nollataan sessio
    session[:user_id] = nil
    #uudelleenohjataan sovellus pääsivulle
    redirect_to :root
  end
end
