class User < ApplicationRecord
  # Include default devise :ppy_authenticatable, modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  ## Checkout masqueradable gem for later 
  devise :ppy_authenticatable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable

  has_many :teaching_requests
  has_many :notifications, foreign_key: :recipient_id
  has_one :staff_profile, dependent: :destroy

  has_many :requests


  accepts_nested_attributes_for :staff_profile, reject_if: proc { |a| a[:user_id].blank? }, allow_destroy: true

  ## SCOPES
  scope :active, -> { where is_active: true }

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
end
