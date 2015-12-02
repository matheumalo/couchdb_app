Rails.application.routes.draw do
  root 'static_pages#home'

  get 'tweets' => 'tweets#index'



  
end
