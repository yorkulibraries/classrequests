class InstituteCourse < ApplicationRecord
  
  def faculty_label
    "#{faculty_abbrev} - #{faculty}"
  end
  
  def subject_label
    "#{subject_abbrev} - #{subject}"
  end

  def academic_year_label
    return unless academic_year

    "#{academic_year}–#{academic_year + 1}"
  end
end
