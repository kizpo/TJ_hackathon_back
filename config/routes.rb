Rails.application.routes.draw do
  post '/movies/recommend', to: 'movies#recommend'
end
