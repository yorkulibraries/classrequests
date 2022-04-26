require 'devise/strategies/ppy_authenticatable'

# lib/devise/models/ppy_authenticatable.rb
# PpyAuthenticatable Model to find user account or create if new
module Devise::Models
  module PpyAuthenticatable
    extend ActiveSupport::Concern

    class_methods do
      # defining a class method that can find or create a Resource record
      # and returns it back to our Authentication Strategy
      #
      # If a user needs to sign up first,
      #   with Registerable, merely look up the record in your database
      #   instead of creating a new one
      def find_or_create_with_authentication_profile(profile)

        password = Devise.friendly_token[0, 20]
        resource = where(user_uid: profile[:user_uid])
                   .first_or_create({
                       user_uid: profile[:user_uid],
                       username: profile[:username],
                       email: profile[:email_address],
                       first_name: profile[:firstname],
                       last_name: profile[:lastname],
                       user_group: profile[:user_type],
                       password: password,
                       user_source: 'ppy'
                   })
        resource
      end
    end
  end
end
