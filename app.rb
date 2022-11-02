# file: app.rb
require 'sinatra'
require "sinatra/reloader"
require_relative 'lib/database_connection'
require_relative 'lib/album_repository'
require_relative 'lib/artist_repository'

#removed this for web app launch on Render!
#DatabaseConnection.connect

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    also_reload 'lib/album_repository'
    also_reload 'lib/artist_repository'
  end

  get '/' do
    ##Testing dynamic text
    #@name = params[:name] # can use as dynamic tag in index.erb
    #@cohort_name = 'October 2022'

    #Testing a list
    #@names = ['Gunel', 'Thanos', 'Mum', 'Dad']

    ## TESTING Password: either or html
    #@password = params[:password]

    return erb(:index) # use the name of the file 'index'
  end

  get '/about' do
    return erb(:about)
  end


  get '/albums' do
    repo = AlbumRepository.new

    @albums = repo.all

    # albums = repo.all

    # response = albums.map do |album|
    #   album.title
    # end.join(', ')

    # return response

    return erb(:albums)
  end

  get '/albums/new' do
    # only needs to return the form
    return erb(:new_album)
  end

  get '/albums/:id' do
    repo = AlbumRepository.new
    artist_repo = ArtistRepository.new
    @album = repo.find(params[:id])
    @artist = artist_repo.find(@album.artist_id)

    return erb(:album) # now create a new album erb file
    
  end

  get '/artists/new' do
    # only needs to return the form
    return erb(:new_artist)
  end


  get '/artists' do
    repo = ArtistRepository.new
    @artists = repo.all

    return erb(:artists)
  end

  get '/artists/:id' do
    artist_repo = ArtistRepository.new
    @artist = artist_repo.find(params[:id])

    return erb(:artist)

  end

  post '/albums' do
    
    if invalid_album_parameters?

      status 400
      return erb(:fail_page)
    end


    repo = AlbumRepository.new
    new_album = Album.new
    new_album.title = params[:title]
    new_album.release_year = params[:release_year]
    new_album.artist_id = params[:artist_id]

    repo.create(new_album)

    @album_name = params[:album_name]

    return erb(:album_created)

  end

  def invalid_album_parameters?
    params[:title] == '' || params[:release_year] == '' || params[:artist_id] == ''
  end


  post '/artists' do

    if invalid_artist_parameters?

      status 400
      return erb(:fail_page)
    end


    repo = ArtistRepository.new
    new_artist = Artist.new
    new_artist.name = params[:name]
    new_artist.genre = params[:genre]

    repo.create(new_artist)

    @name = params[:name]
    
    return erb(:artist_created)

  end

  def invalid_artist_parameters?
    params[:name] == '' || params[:genre] == ''
  end

end