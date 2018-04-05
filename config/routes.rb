Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#index'

  api vendor_string: 'api', default_version: 1 do
    version 1 do
      cache as: 'v1' do
        get 'bind-stu-user', to: 'bind_stu_user#index'
        get 'get-room', to: 'get_room#index'
        get 'wx-login', to: 'wx_login#index'
        get 'get-user-info', to: 'wx_login#get_user_info'
        resources :news, only: [:index, :show]
        resources :grade, only: [:index]
        resources :get_rooms, only: [:index]
        resources :tran_items, only: [:index]
        get 'get_energy_query', to: 'get_energy#get_energy_query'
        get 'get_term', to: 'get_timetable#get_term'
        get 'get_timetable', to: 'get_timetable#get_timetable'
        get 'get_brows', to: 'get_brows#index'
        get 'loss', to: 'get_brows#loss'
        get 'get_borrow', to: 'borrow_book#index'
      end
    end
  end

end
