class MoviesController < ApplicationController


  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
    @all_ratings = Movie.all_ratings
    @ratings_to_show = session[:ratings] || Hash[ @all_ratings.map {|ratings| [ratings, 1]} ] 
    session[:ratings] = @ratings_to_show
    @sort_tag = params[:sort_tag]

    if params[:ratings] then
      @ratings_to_show = params[:ratings]
      session[:ratings] = @ratings_to_show
      @movies = Movie.with_ratings(@ratings_to_show.keys)
    end

    if @sort_tag then
      session[:sort_tag] = @sort_tag
      @movies = @movies.order(@sort_tag)
    end
    if not (params[:ratings]) then
      redirect_to movies_path({:ratings => session[:ratings]})
    end


  end

  def new
    # default: render 'new' template
    
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path#({:ratings => session[:ratings]})
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
    redirect_to movies_path#({:ratings => session[:ratings]})
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
