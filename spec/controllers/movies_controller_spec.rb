require 'simplecov'
SimpleCov.start 'rails'
require 'rails_helper'

describe MoviesController, type: :controller do
  describe "#sort"do
    context "When sort by director" do
      it "should sort all movies by director's name" do
        get :index, :sort => :director, :ratings => ["R","PG", "G", "PG", "PG-13"]
      end
    end
    context "When sort by title" do
      it "should sort all movies by title" do
        get :index, :sort => :title, :ratings => ["R","PG", "G"]
      end
    end
    context "When sort by release_date" do
      it "should sort all movies by release_date" do
        get :index, :sort => :release_date, :ratings => ["G", "PG", "PG-13"]
      end
    end
  end

  describe "#new" do
    context "When create a movie" do
      it "should create it to database" do
        movie_new = Hash.new
        movie_new["title"] = "test_new_movie"
        movie_new["rating"] = "G"
        movie_new["release_date"] = Date.new(1970, 1, 1)
        movie_new["director"] = "test_new_director"

        post :create, movie: movie_new
        expect(response).to redirect_to("/movies")
      end
    end
  end
end  