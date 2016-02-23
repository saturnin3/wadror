class RatingsController < ApplicationController
  def index
    @ratings = Rating.all
    @top_breweries = Brewery.top 3
    @top_beers = Beer.top 3
    @top_styles = Style.top 3
    @most_active = User.most_ratings 3
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
