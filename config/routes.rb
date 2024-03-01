Rails.application.routes.draw do
  # namespace :user do
  #   get 'cancel_requests/new'
  #   get 'cancel_requests/create'
  # end
  resources :notifications, only: [:index]
  resources :announcements, only: [:index]
  resources :institute_courses
  # resources :teaching_type_of_instructions

  ######################
  ####### PUBLIC #######
  ######################

  root 'public/home#index'
  # root 'home#index'
  scope "(:locale)", locale: /en|fr-ca/ do
    scope module: 'public' do
      get 'home', to: 'home#index'
      get 'dashboard', to: 'dashboard#index'
      get 'terms', to: 'terms#index'
      get 'privacy', to: 'privacy#index'
    end
    namespace :public do
      get 'home/index'
      resources :teaching_calendars, only: [:index]
      resources :requests do
        resources :sections
      end

      resources :thank_you, only: [:index]
      resources :process_submits, only: [:update]

    end

    ######################
    ####### USER #########
    ######################
    namespace :user do
      get 'dashboard', to: 'dashboard#index'
      get 'reports/overview', to: 'reports#index'


      resources :teaching_requests
      # resources :process_submits, only: [:update]
      resources :thank_you, only: [:index]
      resources :request_staff_account, only: [:new, :create]
      resources :cancel_requests, only: [:new, :create]
      # resources :requests do
      #   resources :sections
      # end

    end

    ######################
    ####### STAFF ########
    ######################

    namespace :staff do
      get 'dashboard', to: 'dashboard#index'
      get 'reports/overview', to: 'reports#index'
      get 'departmental_reports/overview', to: 'departmental_reports#index'

      resources :staff_profiles, except: [:index, :destroy]

      namespace :reports do
        resources :teachings_by_date_ranges, only: [:index, :new, :create]
        resources :teachings_by_dept_date_ranges, only: [:index, :new, :create]
      end

      ## staff/teaching_requests
      resources :teaching_requests, except: [:index] #only: [:show, :new, :edit, :update, :create, :destroy]

      resources :mark_done_teaching_requests, only: [:update]
      resources :mark_deleted_teaching_requests, only: [:update]
      resources :mark_unfulfilled_teaching_requests, only: [:update]

      resources :teaching_requests do
        resources :assignment_responses
      end

      ######################
      ###### MANAGER #######
      ######################
      namespace :manager do
        get 'dashboard', to: 'dashboard#index'
        get 'reports/overview', to: 'reports#index'

        resources :teaching_requests #, only: [:index, :edit, :update]
        resources :requests do
          resources :sections
        end
        resources :request_status_updates, only: [:edit, :update]
        resources :assign_request_lead, only: [:edit, :update]
        resources :lead_assignment_response, only: [:edit, :update]
        resource :approve_staff_accounts, only: [:update]

        namespace :reports do
          resources :teachings_by_date_ranges, only: [:index, :new, :create]
          resources :teachings_by_dept_date_ranges, only: [:index, :new, :create]
        end

        resources :cancel_requests

      end

      ######################
      #### STAFF/ADMIN #####
      ######################
      namespace :admin do
        get 'dashboard', to: 'dashboard#index'
        get 'reports/overview', to: 'reports#index'
        resources :departments
        resources :staff_profiles
        resources :type_of_instructions
        resources :campus_locations
        resources :users, except: [:new, :create]
        resource :settings
      end
    end

  end


  scope module: 'switchboard' do
    get 'operators/index'
    # get 'denials/index'
  end

  ## ENABLE THIS FOR PPY
  devise_for :users, controllers: { registrations: 'user/registrations' } do
  end

  devise_scope :user do
    get 'users/ppy_login', to: 'user/single_sign_on/ppy_logins#new'
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'shared/fetch_libstar_data' => 'shared/fetch_libstar_data#index'

  get '/:locale' => 'public/home#index'


  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
