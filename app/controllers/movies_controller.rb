class MoviesController < ApplicationController
  protect_from_forgery with: :null_session

  def index
    @movies = Movie.all
  end

  def show
    @movie = Movie.find(params[:id])
    render json: @movie
  end

  def create
    @movie = Movie.new(movie_params)
    if @movie.save
      render json: @movie, status: :created
    else
      render json: @movie.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
  end

  def recommend
    required_keys = %w[excitement joy fear sadness surprise]
    emotions_param = params[:emotions] || {}

    unless required_keys.all? { |key| emotions_param.key?(key) && emotions_param[key].to_i.between?(0, 100) }
      render json: { error: '感情パラメータが不正です' }, status: :bad_request
      return
    end

    user_emotions = required_keys.map { |key| emotions_param[key].to_i }

    movies = Movie.where(region: params[:region], format_type: params[:format_type])

    max_distance = 100**2 * 5

    movies_with_scores = movies.map do |movie|
      movie_emotions = [
        movie.excitement,
        movie.joy,
        movie.fear,
        movie.sadness,
        movie.surprise
      ]
      distance = movie_emotions.zip(user_emotions).map { |m, u| (m - u)**2 }.sum
      match_score = ((max_distance - distance) / max_distance.to_f * 100).round(2)

      {
        recommended_movies: movie,
        match_score: match_score
      }
    end

    sorted_movies = movies_with_scores.sort_by { |h| -h[:match_score] }

    render json: sorted_movies.first(3), status: :ok
  end

  def random_recommend
    emotions = {
      excitement: rand(0..100),
      joy: rand(0..100),
      fear: rand(0..100),
      sadness: rand(0..100),
      surprise: rand(0..100)
    }

    region = Movie.distinct.pluck(:region).sample
    format_type = Movie.distinct.pluck(:format_type).sample

    user_emotions = emotions.values

    movies = Movie.where(region: region, format_type: format_type)

    sorted_movies = movies.sort_by do |movie|
      movie_emotions = [
        movie.excitement,
        movie.joy,
        movie.fear,
        movie.sadness,
        movie.surprise
      ]
      movie_emotions.zip(user_emotions).map { |m, u| (m - u)**2 }.sum
    end

    render json: {
      region: region,
      format_type: format_type,
      emotions: emotions,
      recommended_movies: sorted_movies.first(3)
    }, status: :ok
  end

  private

  def movie_params
    params.require(:movie).permit(:title, :excitement, :joy, :fear, :sadness, :surprise, :region, :format_type)
  end
end
