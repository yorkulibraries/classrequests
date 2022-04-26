class Request < ApplicationRecord

  belongs_to :user, optional: true
  has_many :requests_sections, dependent: :destroy
  has_many :sections, through: :requests_sections #, inverse_of: :request

  # accepts_nested_attributes_for(:sections)
  accepts_nested_attributes_for :sections #, reject_if: proc { |a| a[:id].blank? }, allow_destroy: true
  accepts_nested_attributes_for :requests_sections, reject_if: proc { |a| a[:request_id].blank? }, allow_destroy: true

  FACULTY  = 'YorkU Instructor'
  TEACHING_ASSISTANT = 'Teaching Assistant'
  UNDERGRADUTE_STUDENT = 'Undergradute Student'
  GRADUTE_STUDENT = 'Graduate Student'
  STAFF = 'Librarian | Archivist | Staff'
  OTHER = 'Other'

  enum patron_type: {"#{FACULTY}": 0, "#{TEACHING_ASSISTANT}": 1, "#{STAFF}": 4, "#{OTHER}": 9}

  ## Statuses
  INCOMPLETE     = 'Not Submitted'
  NEW_REQUEST    = 'New Request'
  IN_PROCESS     = 'In Process'
  COMPLETED      = 'Completed'
  UNFULFILLED    = 'Unfulfilled'
  DELETED        = 'Deleted'
  ARCHIVED       = 'Archived'

  ALL            = 'All'

  enum status: {"#{INCOMPLETE}": 0, "#{NEW_REQUEST}": 1, "#{IN_PROCESS}": 3, "#{COMPLETED}": 4, "#{UNFULFILLED}": 6, "#{DELETED}": 9}

  # ACADEMIC_YEARS = ["#{Time.current.year-1}-#{Time.current.year}",
  #                  "#{Time.current.year}-#{Time.current.year+1}",
  #                  "#{Time.current.year+1}-#{Time.current.year+2}"
  #                 ]
  #
  # ACADEMIC_YEARS =

  validates :patron_type, :first_name, :last_name, :email, :academic_year, :faculty_abbrev, :subject_abbrev, :course_number, :status, presence: true

  validates_format_of :email, with: /\A[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}\z/i


  ## PAGING (kaminari)
  paginates_per 10

  def name
    return "#{self.id}: #{self.faculty_abbrev}/#{self.subject_abbrev} #{self.course_number} [#{self.academic_year}]"
  end

  def full_name
    return "#{self.id}: #{self.email} - #{self.faculty_abbrev}/#{self.subject_abbrev} #{self.course_number} [#{self.academic_year}] - #{self.course_title.truncate(100) if self.course_title} "
  end


end
