Rails.application.routes.draw do
  root 'static_pages#home'
  get 'home' => 'static_pages#home'
  get 'help' => 'static_pages#help'
  resources :organizations
  devise_for :users, :controllers => { registrations: 'registrations' }
  resources :repositories, except: :index
  get '/dependencies/:id', to: 'repositories#dependencies', as: :dependencies
  post 'repositories/scanselected' => 'repositories#scanselected', as: :scan_all_route
  get "/repositories/:repository_id/vulnerabilities" => "repositories#vulnerabilities", as: :show_vulnerability
end
