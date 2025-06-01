Rails.application.routes.draw do
  resources :movies do
    collection do
      post :recommend
      get :random_recommend
    end
  end
end

