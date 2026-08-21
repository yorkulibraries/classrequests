class TeachingRequest < ApplicationRecord
  WITHOUT_SUBJECT_PORTFOLIO_FILTER = 'without_portfolio'.freeze

  extend Enumerize
  has_rich_text :request_note
  has_rich_text :instructor_notes

  ## RELATIONSHIPS
  belongs_to :user, optional: true
  belongs_to :campus_location, optional: true
  belongs_to :lead_instructor, foreign_key: 'lead_instructor_id', class_name: 'User', optional: true
  belongs_to :second_instructor, foreign_key: 'second_instructor_id', class_name: 'User', optional: true
  belongs_to :third_instructor, foreign_key: 'third_instructor_id', class_name: 'User', optional: true
  belongs_to :subject_portfolio, optional: true
  has_many :assignment_responses, dependent: :destroy
  has_many :subject_portfolio_declines, dependent: :restrict_with_error
  has_many :cancel_requests, dependent: :destroy

  has_many :teaching_type_of_instructions, dependent: :destroy
  has_many :type_of_instructions, through: :teaching_type_of_instructions

  accepts_nested_attributes_for :teaching_type_of_instructions, reject_if: proc { |a| a[:teaching_request_id].blank? }, allow_destroy: true

  ## ENUMS
  enumerize :patron_type, in: { faculty: 0, librarian_staff: 1, other: 9 }, default: :other
  enumerize :status, in: { not_submitted: 0, new_request: 1, in_process: 2, assigned: 3, done: 4, unfulfilled: 6, cancelled: 7, deleted: 9 }, default: :not_submitted

  # DURATIONS = {'30':'30', '45':'45', '60':'60', '60+':'60+'}
  enumerize :duration, in: { thirty: '30', sixty: '60', sixty_plus: '60+', ninety: '90', one_twenty: '120', one_fifty: '150',one_eighty: '180', one_eighty_plus: '180+' }
  # LOCATION_FORMATS = {'Online Live':'Online Live', 'Pre-recorded':'Pre-recorded', 'In-Class':'In-Class', 'In-Library':'In-Library'}
  enumerize :location_preference, in: [:online, :pre_recorded, :hybrid, :in_the_class, :in_the_library, :off_campus, :to_be_determined], default: :to_be_determined
  
  ## VIRTUAL ATTRIBUTE
  # attribute :lead_assignment_response, :boolean


  ## VALIDATIONS
  validates :patron_type, :first_name, :last_name, :email, :academic_term, :academic_year, :faculty_abbrev, :subject_abbrev, :course_number, :status, presence: true
  validates :number_of_students, :preferred_date, :preferred_time, :duration, :location_preference, presence: true
  validates :course_number, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 9999 }
  validates :number_of_students, numericality: { only_integer: true, greater_than: -1, less_than_or_equal_to: 9999 }

  # Validate rich text content
  validate :request_note_content
  # validates :request_note, presence: true #, if: lambda { self.status.new_request? }

  # validates :lead_assignment_response, presence: true, if: lambda {!self.lead_instructor_id.empty? && self.status == self.status.in_process.value}

  # validates :assign_request_lead_update, presence: true, if: lambda {!self.lead_instructor_id.empty? && self.status == self.status.in_process.value}

  validate :assignment_target_present_when_in_process
  validate :subject_portfolio_is_active_when_changed


  validates_format_of :email, with: /\A[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}\z/i


  ## if you want to force one type of instruction, 
  # uncomment the following validation and the method at the bottom of this file
  # validate :at_most_one_type_of_instruction
  

  ## PAGING (kaminari)
  paginates_per 20

  scope :awaiting_portfolio_lead, lambda {
    where(status: TeachingRequest.status.in_process.value, lead_instructor_id: nil)
      .where.not(subject_portfolio_id: nil)
  }

  scope :for_subject_portfolio_filter, lambda { |filter|
    case filter.to_s
    when ''
      all
    when WITHOUT_SUBJECT_PORTFOLIO_FILTER
      where(subject_portfolio_id: nil)
    else
      filter.to_s.match?(/\A\d+\z/) ? where(subject_portfolio_id: filter) : none
    end
  }

  def name
    return "#{self.id}: #{self.faculty_abbrev}/#{self.subject_abbrev} #{self.course_number} - #{self.academic_year}"
  end

  def full_name
    return "#{self.id}: #{self.last_name}, #{self.first_name} #{self.email} - #{self.faculty_abbrev}/#{self.subject_abbrev} #{self.course_number} [#{self.academic_year}] - #{self.course_title.truncate(100) if self.course_title} "
  end

  def portfolio_assignable?
    status&.new_request? &&
      subject_portfolio_id.blank? &&
      subject_portfolio.blank? &&
      lead_instructor_id.blank? &&
      lead_instructor.blank?
  end

  def portfolio_claimable?
    status&.in_process? &&
      subject_portfolio_id.present? &&
      lead_instructor_id.blank? &&
      lead_instructor.blank?
  end

  alias_method :portfolio_returnable?, :portfolio_claimable?

  def portfolio_returnable_by?(member)
    portfolio_returnable? &&
      member.present? &&
      subject_portfolio.eligible_members.exists?(id: member.id)
  end

  def assign_portfolio_lead(assignee)
    with_lock do
      unless portfolio_claimable?
        errors.add(:base, I18n.t('subject_portfolios.claim.errors.unavailable'))
        return false
      end

      unless subject_portfolio.eligible_members.exists?(id: assignee&.id)
        errors.add(:lead_instructor, I18n.t('subject_portfolios.claim.errors.ineligible'))
        return false
      end

      update(lead_instructor: assignee, status: :assigned)
    end
  end

  def request_portfolio_lead_acceptance(assignee)
    with_lock do
      unless portfolio_claimable?
        errors.add(:base, I18n.t('subject_portfolios.claim.errors.unavailable'))
        return false
      end

      unless subject_portfolio.eligible_members.exists?(id: assignee&.id)
        errors.add(:lead_instructor, I18n.t('subject_portfolios.claim.errors.ineligible'))
        return false
      end

      update(lead_instructor: assignee)
    end
  end

  def return_portfolio_to_manager(decline)
    with_lock do
      unless portfolio_returnable?
        decline.errors.add(:base, I18n.t('subject_portfolios.decline.errors.unavailable'))
        return false
      end

      portfolio = subject_portfolio
      unless portfolio.eligible_members.exists?(id: decline.declined_by&.id)
        decline.errors.add(:declined_by, I18n.t('subject_portfolios.decline.errors.ineligible'))
        return false
      end

      decline.teaching_request = self
      decline.subject_portfolio = portfolio
      return false unless decline.save

      update_columns(
        status: TeachingRequest.status.new_request.value,
        subject_portfolio_id: nil,
        updated_at: Time.current
      )
      reload
      true
    end
  end

  def record_lead_assignment_response(response)
    with_lock do
      unless status&.in_process? && lead_instructor_id == response.user_id
        response.errors.add(:base, I18n.t('subject_portfolios.claim.errors.response_unavailable'))
        return false
      end

      response.teaching_request = self
      return false unless response.save

      attributes = { updated_at: Time.current }
      if response.response == AssignmentResponse.response.accept
        attributes[:status] = TeachingRequest.status.assigned.value
      else
        attributes[:status] = if subject_portfolio_id.present?
                                TeachingRequest.status.in_process.value
                              else
                                TeachingRequest.status.new_request.value
                              end
        attributes[:lead_instructor_id] = nil
      end

      update_columns(attributes)
      reload
      true
    end
  end

  def classify_subject_portfolio(portfolio)
    with_lock do
      if portfolio.present? && !portfolio.active? && subject_portfolio_id != portfolio.id
        errors.add(:subject_portfolio, I18n.t('subject_portfolios.assignment.errors.active'))
        return false
      end

      attributes = {
        subject_portfolio_id: portfolio&.id,
        updated_at: Time.current
      }
      notification_required = portfolio.present? &&
                              portfolio.id != subject_portfolio_id &&
                              (status&.new_request? ||
                               (status&.in_process? && lead_instructor_id.blank?))

      if portfolio.present? && status&.new_request?
        attributes[:status] = TeachingRequest.status.in_process.value
      elsif portfolio.blank? && status&.in_process? && lead_instructor_id.blank?
        attributes[:status] = TeachingRequest.status.new_request.value
      end

      updated = update_columns(attributes)
      reload if updated
      @subject_portfolio_notification_required = updated && notification_required
      updated
    end
  end

  def subject_portfolio_notification_required?
    !!@subject_portfolio_notification_required
  end

  def lead_assignment_state
    return :awaiting_response if status&.in_process? && lead_instructor_id.present?

    response = latest_assignment_response
    return :accepted if response&.response == AssignmentResponse.response.accept
    return :declined if response&.response == AssignmentResponse.response.decline

    if status&.assigned? && subject_portfolio_id.present? && lead_instructor_id.present?
      return :confirmed_without_response
    end

    :no_response_recorded if lead_instructor_id.present?
  end

  def latest_assignment_response
    if assignment_responses.loaded?
      assignment_responses.max_by { |response| response.id || 0 }
    else
      assignment_responses.order(id: :desc).first
    end
  end

  private

  # Custom validation method to check for rich text content
  def request_note_content
    if request_note.blank? || request_note.body.blank?
      errors.add(:request_note, "can't be empty")
    end
  end

  def assignment_target_present_when_in_process
    return unless status&.in_process?
    return if lead_instructor_id.present? || subject_portfolio_id.present?

    errors.add(:base, "An in-process request must have a lead instructor or subject portfolio")
  end

  def subject_portfolio_is_active_when_changed
    return unless will_save_change_to_subject_portfolio_id?
    return if subject_portfolio_id.blank?
    return if subject_portfolio&.active?

    errors.add(
      :subject_portfolio,
      I18n.t('subject_portfolios.assignment.errors.active')
    )
  end
  ## force only 1 selection for type of instruction
  # def at_most_one_type_of_instruction
  #   ids = type_of_instruction_ids.reject(&:blank?)
  #   errors.add(:type_of_instruction_ids, "select only one") if ids.size > 1
  # end
end
