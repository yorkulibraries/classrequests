class InstituteCourse < ApplicationRecord
  
  def faculty_label
    "#{faculty_abbrev} - #{faculty}"
  end
  
  def subject_label
    "#{subject_abbrev} - #{subject}"
  end
end
