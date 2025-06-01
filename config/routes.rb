Rails.application.routes.draw do
  post '/movies/recommend', to: 'movies#recommend'
  get '/movies/random_recommend', to: 'movies#random_recommend'
end
