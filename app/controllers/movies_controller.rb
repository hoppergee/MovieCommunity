class MoviesController < ApplicationController
  before_action :authenticate_user! , only: [:new, :create, :edit, :update, :destroy]
  def index
    @movies = Movie.all
  end
  
  def show
    @movie = Movie.find(params[:id])
    @reviews = @movie.reviews
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
  
  private
  def movie_params
    params.require(:movie).permit(:title, :theaterdate, :description)
  end
  
end
