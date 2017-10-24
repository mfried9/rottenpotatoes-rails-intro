class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    #@all_ratings = Movie.all_ratings
    session[:ratings] = params[:ratings] if params[:ratings]
    session[:sort] = params[:sort] if params[:sort]
    
    session_ratings = !params[:ratings] && session[:ratings]
    session_sort = !params[:sort] && session[:sort]
     
    #if params[:ratings]
    #  ratings = params[:ratings].keys
    #  @selected_boxes = ratings
    #  @movies = Movie.where(rating: ratings)
    #else
    #  @movies = Movie.all
    if session_ratings || session_sort
      flash.keep
      redirect_to movies_path(ratings: session[:ratings], sort: session[:sort]) and return
    end
    
    
    #if header == 'title_header'
    #  @movies = Movie.reorder(:title)
    #  @title_class = 'hilite'
    #elsif header == 'rating_header'
    #  @movies = Movie.reorder(:rating)
    #  @rating_class = 'hilite'
    #elsif header == 'release_date_header'
    #  @movies = Movie.reorder(:release_date)
    #  @release_class = 'hilite'
    
    @all_ratings = Movie.all_ratings
    ratings = params[:ratings].keys if params[:ratings]
    @selected_boxes = ratings
    
    if params[:sort]
      
      if params[:sort] == "title"
        @title_class = "hilite"
      elsif params[:sort] == "rating"
        @rating_class = "hilite"
      elsif params[:sort] == "release_date"
        @release_class = "hilite"
      end
    end
    
    @movies = 
      if params[:ratings] && params[:sort]
        Movie.where(rating: ratings).reorder(params[:sort])
      elsif params[:ratings]
        Movie.where(rating: ratings)
      elsif params[:sort]
        Movie.order(params[:sort])
      else
        Movie.all
      end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
