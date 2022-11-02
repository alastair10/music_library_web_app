require "spec_helper"
require "rack/test"
require_relative '../../app'

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  context 'GET /' do

    ## TESTING FOR DYNAMIC WORDS
    # it "returns an html error message with a given name" do
    #   response = get('/', name: 'Alastair')

    #   expect(response.body).to include('<h1>Hello Alastair!</h1>')
    # end

    # it "returns an html hello message with a different name" do
    #   response = get('/', name: 'Leo')

    #   expect(response.body).to include('<h1>Hello Leo!</h1>')

    # end

    ## TESTING FOR A LIST
    # it "returns an html list of names" do
    #   response = get('/')

    #   expect(response.body).to include('<p>Gunel</p>')
    #   expect(response.body).to include('<p>Thanos</p>')
    #   expect(response.body).to include('<p>Mum</p>')
    #   expect(response.body).to include('<p>Dad</p>')

    # end

    ## TESTING FOR PASSWORD

    # it 'returns a hello page if the password is correct' do
    #   response = get('/', password: 'abcd')

    #   expect(response.body).to include('Hello!')
    # end

    # it 'returns a forbidden if the password is incorrect' do
    #   response = get('/', password: 'aasdfasdfasdgasdg')

    #   expect(response.body).to include('Access denied!')
    # end
  end

  context "GET /albums" do
    it "should return a list of albums as HTML page" do
      response = get('/albums')

      expect(response.status).to eq(200)
      expect(response.body).to include('<a href="/albums/2">Surfer Rosa</a><br />')
      expect(response.body).to include('<a href="/albums/3">Waterloo</a><br />')
      expect(response.body).to include('<a href="/albums/4">Super Trouper</a><br />')
      expect(response.body).to include('<a href="/albums/5">Bossanova</a><br />')
    end
  end

  context 'GET /albums/id' do
    it "should return an album details for album 2" do
      response = get('/albums/2')
    
      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Surfer Rosa</h1>')
      expect(response.body).to include('Release year: 1988')
      expect(response.body).to include('Artist: Pixies')
    end
  end

  context "GET /albums/new" do
    it "should return the HTML form to create a new album" do
      response = get('/albums/new')

      expect(response.status).to eq(200)
      expect(response.body).to include('<form method="POST" action="/albums">')
      expect(response.body).to include('<input type="text" name="title" />')
      expect(response.body).to include('<input type="text" name="release_year" />')
      expect(response.body).to include('<input type="text" name="artist_id" />')
    end
  end

  context "GET /artists/new" do
    it "should return the HTML form to create a new artist" do
      response = get('/artists/new')

      expect(response.status).to eq(200)
      expect(response.body).to include('<form method="POST" action="/artists">')
      expect(response.body).to include('<input type="text" name="name" />')
      expect(response.body).to include('<input type="text" name="genre" />')
    end
  end


  context "POST /albums" do
    it "should create an album and return a confirmation page" do
      response = post('/albums', album_name: 'Thriller')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>You added the album: Thriller</h1>')
    end

    it "should create a different album and return a different confirmation page" do
      response = post('/albums', album_name: 'Pet Sounds')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>You added the album: Pet Sounds</h1>')
    end

    it "should raise an 400 error if any field is blank" do
      response = post('/albums', title: 'Abbey Road', release_year: '1965', artist_id: "")

      expect(response.status).to eq(400)
      expect(response.body).to eq('<body>Album creation failed. Please do not leave any fields blank.</body>')
    end

    context "Post /artists" do
      it "should create a new artist and return a confirmation page" do
        response = post('/artists', name: 'Wild nothing', genre: 'Indie')
  
        expect(response.status).to eq(200)
        expect(response.body).to include('<h1>You added the artist: Wild nothing</h1>')
      end

      it "should create a new different artist and return a confirmation page" do
        response = post('/artists', name: 'Beach Boys', genre: 'Pop')
  
        expect(response.status).to eq(200)
        expect(response.body).to include('<h1>You added the artist: Beach Boys</h1>')
      end

      it "should raise an 400 error if any field is blank" do
        response = post('/artists', name: 'Nirvana', genre: '')
  
        expect(response.status).to eq(400)
        expect(response.body).to eq('<body>Album creation failed. Please do not leave any fields blank.</body>')
      end
  
    end


  end

  # context "POST /albums" do
  #   it "should create a new album" do
  #     response = post('/albums', title: 'Voyage', release_year: '2022', artist_id: '2')

  #     expect(response.status).to eq(200)
  #     expect(response.body).to eq('')
      
  #     # need to check that the album is included in updated db
  #     response = get('/albums')
  #     expect(response.body).to include('Voyage')
  #   end
  # end

  context "GET /artists" do
    it "should return a list of artists as an HTML page with links to artists" do
      response = get('/artists')

      expect(response.status).to eq(200)
      expect(response.body).to include('<a href="/artists/1">Pixies</a><br />')
      expect(response.body).to include('<a href="/artists/2">ABBA</a><br />')
      expect(response.body).to include('<a href="/artists/3">Taylor Swift</a><br />')
      expect(response.body).to include('<a href="/artists/4">Nina Simone</a><br />')
      expect(response.body).to include('<a href="/artists/5">Kiasmos</a><br />')


    end
  end

  context "GET /artists/id" do
    it "returns an HTML page showing details for a single artist" do
      response = get('/artists/3') # Taylor Swift

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Taylor Swift</h1>')
      expect(response.body).to include('Genre: Pop')
    end
  end








end
