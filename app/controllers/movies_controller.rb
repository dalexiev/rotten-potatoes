class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    
    # apply filtering, if any
    ratings_hash = params[:ratings]
    ratings = nil;
    if (ratings_hash != nil)
      ratings = ratings_hash.keys
    end
    if (ratings != nil) && (!ratings.empty?)
      flash[:ratings] = ratings
    end
    
    # apply sorting, if any
    sort = params[:sort]
    if (sort != nil)
      flash[:sort] = sort
    end
    
    @movies = Movie.find(:all, :conditions => {:rating => (flash[:ratings] == nil ? @all_ratings : flash[:ratings])}, :order => flash[:sort])  
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
