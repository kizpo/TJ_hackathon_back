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

  def recommend
    required_keys = %w[excitement joy fear sadness surprise]
    emotions_param = params[:emotions] || {}

    unless required_keys.all? { |key| emotions_param.key?(key) && emotions_param[key].to_i.between?(0, 100) }
      render json: { error: '感情パラメータが不正です' }, status: :bad_request
      return
    end

    user_emotions = required_keys.map { |key| emotions_param[key].to_i }

    movies = Movie.where(region: params[:region], format_type: params[:format_type])

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

    render json: sorted_movies.first(3), status: :ok
  end

  private

  def movie_params
    params.require(:movie).permit(:title, :excitement, :joy, :fear, :sadness, :surprise, :region, :format_type)
  end
end
