Rails.application.routes.draw do
  root 'static_pages#home'

  get 'tweets' => 'tweets#index'
  get 'mentioned' => 'tweets#mentioned'
  get 'hashtags' => 'tweets#hashtags'




  
end
