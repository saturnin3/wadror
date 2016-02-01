class SessionsController < ApplicationController
  def new
     #renderöi kirjautumissivun
  end

  def create
    #haetaan usernamea vastaava käyttäjä tietokannasta
    user = User.find_by username: params[:username]
    #tallennetaan sessioon kirjautuneen käyttäjän id (jos olemassa)
    session[:user_id] = user.id if not user.nil?
    #uudelleenohjataan käyttäjä omalle sivulleen
    redirect_to user
  end

  def destroy
    #nollataan sessio
    session[:user_id] = nil
    #uudelleenohjataan sovellus pääsivulle
    redirect_to :root
  end
end
