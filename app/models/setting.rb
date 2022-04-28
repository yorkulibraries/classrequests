# RailsSettings Model
class Setting < RailsSettings::Base
  # extend ActiveModel::Naming
  # cache_prefix { 'v1' }

  # Define your fields
  scope :application do

    ## App-Info
    field :app_name, default: 'LIBSTAR', validates: { presence: true, length: { in: 2..20 } }
    field :library_homepage_url, default: ''
    field :university_homepage_url, default: ''
    field :default_locale, default: 'en', type: :string
    field :release_version, default: Rails.configuration.libstar_version, type: :string
    field :logo_url, default: 'YorkULogo_Hor_186-svg.svg', type: :string
    field :mail_logo_url, default: 'YorkULogo_Hor_rgb.jpg', type: :string
    field :login_banner_url, default: '', type: :string #pexels-tamas-meszaros-12064
    field :homepage_banner_url, default: '', type: :string
    field :web_host, type: :string, default: 'http://localhost:3000'

    ## Notifications
    field :manager_emails, default: %w[manager2022@mailinator.com], type: :array
    field :new_request_notification, default: %w[admin2022@mailinator.com], type: :array
    field :cancel_request_notification, default: %w[manager2022@mailinator.com], type: :array
    field :system_admin_emails, default: %w[admin2022@mailinator.com], type: :array
    field :director_name, default: 'Director Name', type: :string
    field :director_position, default: 'Director of Student Learning & Academic Success', type: :string
    field :director_email, default: 'Director@email.com', type: :string

    ## Contacts
    field :archives_contact, default: '', type: :string
    field :law_contact, default: '', type: :string
    field :all_contact, default: '', type: :string
    field :questions_inquiries_contact, default: '', type: :string
    field :other_campus_contact, default: '', type: :string



    ## App Preferences & Auth
    field :enable_devise_database_auth, default: true, type: :boolean
    field :enable_staff_access_request, default: true, type: :boolean
    field :enable_devise_PPY, default: true, type: :boolean

    ## yet to be implemented. Stubbed in for later.
    field :enable_annoucements, default: false, type: :boolean
    field :enable_notifications, default: false, type: :boolean
    # field :omniauth_google_client_id, default: (ENV['OMNIAUTH_GOOGLE_CLIENT_ID'] || ''), type: :string, readonly: true
    # field :omniauth_google_client_secret, default: (ENV['OMNIAUTH_GOOGLE_CLIENT_SECRET'] || ''), type: :string, readonly: true
  end

  scope :messages do
    field :global_notice, type: :text
    field :welcome_message, type: :text
  end
  # field :notification_options, type: :hash, default: {
  #   send_all: true,
  #   logging: true,
  #   sender_name: 'Library Messenger',
  #   sender_email: 'noreply@domain.ca'
  # }


  scope :mail_settings do
    # field :delivery_method, default: 'sendmail'
    # field :mail_host, default: 'localhost'
    # field :mail_port, default: '1025'
    field :system_from_name, default: 'Library Messenger'
    field :system_from_email, default: 'noreply@library.ca'
    # field :provider, default: (ENV['mailer_provider'] || ':smtp'), readonly: true
    # field :smtp_options, type: :hash, readonly: true, default: {
    #   address: ENV['mailer_options.address'],
    #   port: ENV['mailer_options.port'],
    #   domain: ENV['mailer_options.domain'],
    #   user_name: ENV['mailer_options.user_name'],
    #   password: ENV['mailer_options.password'],
    #   authentication: ENV['mailer_options.authentication'] || 'login',
    #   enable_starttls_auto: ENV['mailer_options.enable_starttls_auto']
    # }
  end
end
