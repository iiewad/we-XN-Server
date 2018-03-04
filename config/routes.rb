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
        get 'wechat-login', to: 'wechat_login#index'
      end
    end
  end

end
