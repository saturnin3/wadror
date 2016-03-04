class RatingsController < ApplicationController
  def index

    Rails.cache.write("all ratings", Rating.all, expires_in: 10.minutes) if Rails.cache.read("all ratings").nil?
    @ratings = Rails.cache.read("all ratings")

    Rails.cache.write("brewery top 3", Brewery.top(3), expires_in: 10.minutes) if Rails.cache.read("brewery top 3").nil?
    @top_breweries = Rails.cache.read("brewery top 3")
    #@top_beers = Beer.top(3)
    Rails.cache.write("style top 3", Style.top(3), expires_in: 10.minutes) if Rails.cache.read("style top 3").nil?
    @top_styles = Rails.cache.read("style top 3")


    Rails.cache.write("user top 3", User.most_ratings(3), expires_in: 10.minutes) if Rails.cache.read("user top 3").nil?
    @most_active = Rails.cache.read("user top 3")

    Rails.cache.write("beer top 3", Beer.top(3), expires_in: 10.minutes) if Rails.cache.read("beer top 3").nil?
    @top_beers = Rails.cache.read "beer top 3"

  end

  def new
    @rating = Rating.new
    @beers = Beer.all
  end
  def create
    #raise
    @rating = Rating.new params.require( :rating).permit( :score, :beer_id)
    # session[:last_rating] = "#{rating.beer.name} #{rating.score} points"
    if current_user.nil?
      redirect_to signin_path, notice: "you should be signed in"
    elsif @rating.save
      current_user.ratings << @rating
      redirect_to  user_path current_user
    else
      @beers = Beer.all
      render :new
    end
  end

  def destroy
    rating = Rating.find(params[:id])
    rating.delete if current_user == rating.user
    redirect_to :back
  end

end
