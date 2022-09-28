Rails.application.routes.draw do
  
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  devise_for :users,
              path: '',
              path_names: {
                sign_in: 'api/v1/login',
                sign_out: 'api/v1/logout',
                # registration: 'api/v1/signup'
              },
              controllers: {
                sessions: 'api/v1/users/sessions'
              },
              skip: %i[registrations passwords]

  
  namespace :api do
    namespace :v1 do
      namespace :users do
        post '/', to: "manage#create"
        patch '/:user_id', to: "manage#update"
        resources :students, param: :student_id, only: [:index, :destroy, :show]
        resources :teachers, param: :teacher_id, only: [:index, :destroy, :show]
        
        resources :surveys, only: [:index, :update, :show]
      end

      resources :courses, param: :course_id, except: [:new, :edit]
      resources :templates, param: :template_id, except: [:new, :edit]

      post '/templates/:template_id/clone', to: "templates#clone"

      namespace :reports do
        resources :teachers, only: [:index]
      end
      
    end
  end

  root to: 'landing#index'
  
  get "*path", to: "landing#index", constraints: ->(request) do
    request.format.html? && request.path.exclude?("rails/active_storage")
  end
        
end
