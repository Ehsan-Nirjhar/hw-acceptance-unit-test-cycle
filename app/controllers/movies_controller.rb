class MoviesController < ApplicationController
  ### flag to determine whether to flash notice or not. If 0, don't flash notice.
  @@flag = 1   
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date, :director)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # flash[:notice] = nil
    # will render app/views/movies/show.<extension> by default
  end

  def index
    sort = params[:sort] || session[:sort]
    case sort
    when 'title'
      ordering,@title_header = {:title => :asc}, 'hilite'
    when 'release_date'
      ordering,@date_header = {:release_date => :asc}, 'hilite'
    end
    @all_ratings = Movie.all_ratings
    @selected_ratings = params[:ratings] || session[:ratings] || {}
    
    if @selected_ratings == {}
      @selected_ratings = Hash[@all_ratings.map {|rating| [rating, rating]}]
    end
    
    if params[:sort] != session[:sort] or params[:ratings] != session[:ratings]
      session[:sort] = sort
      session[:ratings] = @selected_ratings
      redirect_to :sort => sort, :ratings => @selected_ratings and return
    end
    @movies = Movie.where(rating: @selected_ratings.keys).order(ordering)
    if @@flag == 0
      @@flag = 1
      flash[:notice] = nil
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
  
  ### Find movies with same director
  def director_select
    movie = Movie.find(params[:id])
    director_name = movie.director

    if not director_name or director_name.empty? 
      flash[:notice] = %Q{'#{movie.title}' has no director info}
      @@flag = 1
      redirect_to movies_path
    else
      @movies = Movie.where(director:director_name)
      @@flag = 0   ### Making flag 0, so that it doesn't show the notice, when back to home page.
      flash[:notice] = %Q{There are #{@movies.size} movie(s) with "#{director_name}" as director}
    end
  end

end
