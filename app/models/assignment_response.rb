class AssignmentResponse < ApplicationRecord

  extend Enumerize
  ## RELATIONSHIPS
  belongs_to :teaching_request
  belongs_to :user
  accepts_nested_attributes_for :teaching_request, reject_if: proc { |a| a[:status].blank? }
  
  ## ENUMS
  enumerize :response, in: { accept: 0, decline: 1 }, default: :accept

  ## VALIDATIONS

  validates :response, :teaching_request_id, :user_id, presence: true

  # validates :comment_or_reason, presence: true, if: lambda {!self.response.empty? && self.response == self.response.decline.value}

end
