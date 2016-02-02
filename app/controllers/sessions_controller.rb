class SessionsController < ApplicationController
  def new
     #renderöi kirjautumissivun
  end

  def create
    #haetaan usernamea vastaava käyttäjä tietokannasta
    user = User.find_by username: params[:username]
    if user.nil?
      redirect_to :back, notice: "User #{params[:username]} does not exist!"
    else
      #tallennetaan sessioon kirjautuneen käyttäjän id (jos olemassa)
      session[:user_id] = user.id if not user.nil?
      #uudelleenohjataan käyttäjä omalle sivulleen
      redirect_to user, notice: "Welcome back!"
    end
  end

  def destroy
    #nollataan sessio
    session[:user_id] = nil
    #uudelleenohjataan sovellus pääsivulle
    redirect_to :root
  end
end
