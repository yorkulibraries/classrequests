class IntroLibraryResearch < ApplicationRecord
  extend Enumerize
  
  belongs_to :user, optional: true
  belongs_to :campus_location, optional: true

  enumerize :patron_type, in: { faculty: 0, librarian_staff: 1, other: 9 }, default: :other
  enumerize :status, in: { not_submitted: 0, new_request: 1, in_process: 2, assigned: 3, done: 4, unfulfilled: 6, deleted: 9 }, default: :not_submitted

  validates :patron_type, :first_name, :last_name, :email, :academic_term, :academic_year, :faculty_abbrev, :subject_abbrev, :course_number, :status, presence: true
  validates_format_of :email, with: /\A[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}\z/i

  ## PAGING (kaminari)
  paginates_per 20


end
