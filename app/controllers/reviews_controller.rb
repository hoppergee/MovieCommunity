class ReviewsController < ApplicationController
  before_action :authenticate_user!, :only => [:new, :create]
  before_action :find_movie_and_check, :only => [:new, :create]
  
  def new
    # @movie = Movie.find(params[:movie_id])
    @review = Review.new
  end
  
  def create
    # @movie = Movie.find(params[:movie_id])
    @review = Review.new(review_params)
    @review.movie = @movie
    @review.user = current_user
    
    if @review.save
      redirect_to movie_path(@movie)
    else
      render :new
    end
  end
  
  private
  
  def find_movie_and_check
    @movie = Movie.find(params[:movie_id])
    if !current_user.is_follower_of?(@movie)
      redirect_to movie_path(@movie), alert: "只有收藏了电影才能进行评论"
    end
  end
  
  def review_params
    params.require(:review).permit(:content)
  end
  
end
