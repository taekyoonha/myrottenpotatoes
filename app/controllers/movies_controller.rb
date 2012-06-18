class MoviesController < ApplicationController

  def get_all_ratings
    ratings = []
    Movie.all.each do |m|
      ratings.push(m.rating)
    end
    return ratings.uniq
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    #flash[:notice] = params
    @all_ratings = get_all_ratings()
    @selected_ratings = []
    if params[:ratings] == nil
       if session.has_key?('selected_ratings')
         @selected_ratings = session['selected_ratings']
       else
         @selected_ratings = @all_ratings
       end
    else
       @selected_ratings = params[:ratings].keys
    end
    session['selected_ratings'] = @selected_ratings

    @order = nil
    if params[:order] == nil
       if session.has_key?('order')
         @order = session['order']
       end
    else
       @order = params[:order]
       session['order'] = @order
    end

    if @order == 'title'
      @movies = Movie.where(:rating => @selected_ratings).order(:title).all
      session['order'] = 'title'
    elsif @order == 'date'
      @movies = Movie.where(:rating => @selected_ratings).order(:release_date).all
      session['order'] = 'date'
    else
      @movies = Movie.where(:rating => @selected_ratings).all
    end
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
