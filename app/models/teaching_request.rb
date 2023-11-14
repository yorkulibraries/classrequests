class TeachingRequest < ApplicationRecord
  extend Enumerize
  has_rich_text :request_note
  has_rich_text :instructor_notes

  ## RELATIONSHIPS
  belongs_to :user, optional: true
  belongs_to :lead_instructor, foreign_key: 'lead_instructor_id', class_name: 'User', optional: true
  belongs_to :second_instructor, foreign_key: 'second_instructor_id', class_name: 'User', optional: true
  belongs_to :third_instructor, foreign_key: 'third_instructor_id', class_name: 'User', optional: true
  has_many :assignment_responses, dependent: :destroy
  has_many :cancel_requests, dependent: :destroy

  has_many :teaching_type_of_instructions, dependent: :destroy
  has_many :type_of_instructions, through: :teaching_type_of_instructions

  accepts_nested_attributes_for :teaching_type_of_instructions, reject_if: proc { |a| a[:teaching_request_id].blank? }, allow_destroy: true

  ## ENUMS
  enumerize :patron_type, in: { faculty: 0, librarian_staff: 1, other: 9 }, default: :other
  enumerize :status, in: { not_submitted: 0, new_request: 1, in_process: 2, assigned: 3, done: 4, unfulfilled: 6, deleted: 9 }, default: :not_submitted

  # DURATIONS = {'30':'30', '45':'45', '60':'60', '60+':'60+'}
  enumerize :duration, in: { thirty: '30', sixty: '60', sixty_plus: '60+', ninety: '90', one_twenty: '120', one_eighty: '180', one_eighty_plus: '180+' }
  # LOCATION_FORMATS = {'Online Live':'Online Live', 'Pre-recorded':'Pre-recorded', 'In-Class':'In-Class', 'In-Library':'In-Library'}
  enumerize :location_preference, in: [:online, :pre_recorded, :in_the_class, :in_the_library, :off_campus, :to_be_determined], default: :to_be_determined
  
  ## VIRTUAL ATTRIBUTE
  # attribute :lead_assignment_response, :boolean


  ## VALIDATIONS
  validates :patron_type, :first_name, :last_name, :email, :academic_year, :faculty_abbrev, :subject_abbrev, :course_number, :status, presence: true
  validates :number_of_students, :preferred_date, :preferred_time, :duration, :location_preference, presence: true
  validates :request_note, presence: true #, if: lambda { self.status.new_request? }

  # validates :lead_assignment_response, presence: true, if: lambda {!self.lead_instructor_id.empty? && self.status == self.status.in_process.value}

  # validates :assign_request_lead_update, presence: true, if: lambda {!self.lead_instructor_id.empty? && self.status == self.status.in_process.value}

  validates :lead_instructor_id, presence: true, if: lambda {self.lead_instructor_id.blank? && self.status.in_process?}


  validates_format_of :email, with: /\A[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}\z/i

  ## PAGING (kaminari)
  paginates_per 20

  def name
    return "#{self.id}: #{self.faculty_abbrev}/#{self.subject_abbrev} #{self.course_number} - #{self.academic_year}"
  end

  def full_name
    return "#{self.id}: #{self.last_name}, #{self.first_name} #{self.email} - #{self.faculty_abbrev}/#{self.subject_abbrev} #{self.course_number} [#{self.academic_year}] - #{self.course_title.truncate(100) if self.course_title} "
  end
end
