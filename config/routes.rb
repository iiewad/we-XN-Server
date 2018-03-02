Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#index'

  api vendor_string: 'api', default_version: 1 do
    version 1 do
      cache as: 'v1' do
        get 'bind-stu-user', to: 'bind_stu_user#index'
      end
    end
  end

end
