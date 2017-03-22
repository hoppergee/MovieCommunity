class MoviesController < ApplicationController
  before_action :authenticate_user! , only: [:new, :create, :edit, :update, :destroy]
  def index
    @movies = Movie.all
  end
  
  def show
    @movie = Movie.find(params[:id])
    @reviews = @movie.reviews.recent.paginate(:page => params[:page], :per_page => 5)
  end
  
  def edit
    @movie = Movie.find(params[:id])
  end
  
  def new
    @movie = Movie.new
  end
  
  def create
    @movie = Movie.new(movie_params)
    @movie.user = current_user
    
    if @movie.save
      current_user.follow!(@movie)
      redirect_to movies_path
    else
      render :new
    end
  end
  
  def update
    @movie = Movie.find(params[:id])
    
    if @movie.update(movie_params)
      redirect_to movies_path, notice: "Update Scuccess"
    else
      render :edit
    end
  end
  
  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:alert] = "Movie deleted"
    redirect_to movies_path
  end
  
  def follow
    @movie = Movie.find(params[:id])
    
    if !current_user.is_follower_of?(@movie)
      current_user.follow!(@movie)
      flash[:notice] = "成功收藏本电影"
    else
      flash[:warning] = "你已经收藏了该电影"
    end
    
    redirect_to movie_path(@movie)
  end
  
  def unfollow
    @movie = Movie.find(params[:id])
    
    if current_user.is_follower_of?(@movie)
      current_user.unfollow!(@movie)
      flash[:alert] = "已经停止关注该电影"
    else
      flash[:waring] = "您原本就没有收藏该电影..."
    end
    
    redirect_to movie_path(@movie)
  end
  
  private
  def movie_params
    params.require(:movie).permit(:title, :theaterdate, :description)
  end
  
end
