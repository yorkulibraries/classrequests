class Section < ApplicationRecord
  has_many :requests_sections, dependent: :destroy
  has_many :requests, through: :requests_sections #, inverse_of: :section

  belongs_to :lead_instructor, foreign_key: "lead_instructor_id", class_name: 'User', optional: true
  belongs_to :second_instructor, foreign_key: "second_instructor_id", class_name: 'User', optional: true
  belongs_to :third_instructor, foreign_key: "third_instructor_id", class_name: 'User', optional: true


  accepts_nested_attributes_for :requests_sections, reject_if: proc { |a| a[:request_id].blank? }, allow_destroy: true

  ## Statuses
  INCOMPLETE     = "Not Submitted"
  NEW_REQUEST    = "New Request"
  # BEING_REVIEWED = "Being Reviewed"
  IN_PROCESS     = "In Process"
  # BOOKED         = "Booked / Scheduled"
  COMPLETED      = "Completed"
  UNFULFILLED    = "UnFulfilled"
  DELETED        = "Deleted"
  # ARCHIVED       = "Archived"

  enum status: {"#{INCOMPLETE}": 0, "#{NEW_REQUEST}": 1, "#{IN_PROCESS}": 3, "#{COMPLETED}": 4, "#{UNFULFILLED}": 6, "#{DELETED}": 9}

  # durations: ['30','45','60','60+']
  DURATIONS = {"30":"30", "45":"45", "60":"60", "60+":"60+"}
  LOCATION_FORMATS = {"Online Live":"Online Live", "Pre-recorded":"Pre-recorded", "In-Class":"In-Class", "In-Library":"In-Library"}

  # DURATIONS = {"15mins": "15mins", "30mins":"30mins", "45mins":"45mins"}
  validates :section_name_or_about, :number_of_students, :preferred_date, :preferred_time, :duration, :location_preference, presence: true

  def name
    return self.section_name_or_about
  end
end
