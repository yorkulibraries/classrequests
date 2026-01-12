class InstituteCourse < ApplicationRecord
  
  def faculty_label
    "#{faculty_abbrev} - #{faculty}"
  end
  
  def subject_label
    "#{subject_abbrev} - #{subject}"
  end

  def academic_year_label
    return if academic_year.blank?

    year = academic_year.to_i
    "#{year}–#{year + 1}"
  end
end
