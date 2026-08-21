class User < ApplicationRecord
  SUBJECT_PORTFOLIO_ROLES = %w[staff_instructor manager director administrator].freeze

  # Include default devise :ppy_authenticatable, modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  ## Checkout masqueradable gem for later 
  devise :ppy_authenticatable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable

  has_many :teaching_requests
  has_many :intro_library_researches
  has_many :notifications, foreign_key: :recipient_id
  has_one :staff_profile, dependent: :destroy
  has_many :subject_portfolio_memberships, dependent: :destroy
  has_many :subject_portfolios, through: :subject_portfolio_memberships
  has_many :subject_portfolio_declines,
           foreign_key: :declined_by_id,
           inverse_of: :declined_by,
           dependent: :restrict_with_error

  has_many :requests


  accepts_nested_attributes_for :staff_profile, reject_if: proc { |a| a[:user_id].blank? }, allow_destroy: true

  ## SCOPES
  scope :active, -> { where is_active: true }
  scope :eligible_for_subject_portfolios, lambda {
    role_values = SUBJECT_PORTFOLIO_ROLES.map do |role_name|
      StaffProfile.role.find_value(role_name).value
    end

    active
      .joins(:staff_profile)
      .where(staff_profiles: { is_approved: true, role: role_values })
      .distinct
  }

  ## METHODS
  def full_name
    "#{first_name} #{last_name}"
  end
  def name
    "#{first_name} #{last_name}"
  end
  def user_label
    "#{username} | #{email}"
  end

  def eligible_for_subject_portfolios?
    is_active? &&
      staff_profile&.is_approved? &&
      SUBJECT_PORTFOLIO_ROLES.include?(staff_profile.role.to_s)
  end
end
