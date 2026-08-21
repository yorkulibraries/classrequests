class CancelRequest < ApplicationRecord
  belongs_to :user
  belongs_to :teaching_request

  validates :reason, presence: true

  def processed?
    cancelled? || deleted?
  end

  def cancelled?
    teaching_request.status&.cancelled?
  end

  def deleted?
    teaching_request.status&.deleted?
  end
end
