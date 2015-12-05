Rails.application.routes.draw do
  root 'static_pages#home'

  get 'tweets' => 'tweets#index'
  get 'mentioned' => 'tweets#mentioned'




  
end
