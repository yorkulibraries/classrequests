class CancelRequest < ApplicationRecord
  belongs_to :user
  belongs_to :teaching_request, optional: true ## in case request was deleted but cancel record exists.
end
