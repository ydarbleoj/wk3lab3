class MoviesController < ApplicationController

  @@movie_db = [
          {"title"=>"The Matrix", "year"=>"1999", "imdbID"=>"tt0133093", "Type"=>"movie"},
          {"title"=>"The Matrix Reloaded", "year"=>"2003", "imdbID"=>"tt0234215", "Type"=>"movie"},
          {"title"=>"The Matrix Revolutions", "year"=>"2003", "imdbID"=>"tt0242653", "Type"=>"movie"}]

  # route: GET    /movies(.:format)
  def index
    @movies = @@movie_db

    respond_to do |format|
      format.html
      format.json { render :json => @@movie_db }
      format.xml { render :xml => @@movie_db.to_xml }
    end
  end
  # route: # GET    /movies/:id(.:format)
  def show
    @movie = get_movie params[:id]
  end

  # route: GET    /movies/new(.:format)
  def new
  end

  # route: GET    /movies/:id/edit(.:format)
  def edit
    @movie = get_movie 
  end 

  #route: # POST   /movies(.:format)
  def create
    # create new movie object from params
    add_movie
    redirect_to action: :index
  end

  def result     
    search_str = params[:movie]
    response = Typhoeus.get("www.omdbapi.com", :params => {:s => "#{search_str}"})
    search_str = response.body
    @movies = JSON.parse(search_str)
    render :result
  end 

  def display_movie
    
  end 

  # route: PATCH  /movies/:id(.:format)
  def update
    #implement
    delete_movie 
    create
    #  render :show 
  end

  # route: DELETE /movies/:id(.:format)
  def destroy
    delete_movie
    redirect_to action: :index     
    # redirect_t :index
  end

  def show 
    @movie = get_movie
  end 

  
  private 

  def delete_movie
    @movie = get_movie
    @@movie_db.delete_if { |item| item == @movie }
  end   


  def get_movie 
    the_movie = @@movie_db.find do |m|
      m["imdbID"] == params[:id]
    end

    if the_movie.nil?
      flash.now[:message] = "Movie not found"
      the_movie = {}
    end
    the_movie
  end

  def add_movie
    movie = params.require(:movie).permit(:title, :year)
    movie["imdbID"] = rand(10000..10000000).to_s
    @@movie_db << movie
  end 


end













