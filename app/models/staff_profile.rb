class StaffProfile < ApplicationRecord
  extend Enumerize
  belongs_to :department
  belongs_to :user

  ## ROLE TYPES
  # not_set = 0
  # student_staff = 1
  # staff_instructor = 2
  # staff_admin = 3
  # manager = 4
  # admin = 5
  # director = 6

  # enum role: %i[not_set student_staff staff_instructor manager administrator]
  enumerize :role, in: { not_set: 0, student_staff: 1, staff_instructor: 2, staff_admin: 3, manager: 4, director: 5, administrator: 9}, default: :not_set

end
