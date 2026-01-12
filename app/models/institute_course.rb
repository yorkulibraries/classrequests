class InstituteCourse < ApplicationRecord
  
  def faculty_label
    "#{faculty_abbrev} - #{faculty}"
  end
  
  def subject_label
    "#{subject_abbrev} - #{subject}"
  end

  def self.academic_year_options(years)
    Array(years).to_h do |year|
      y = year.to_i
      ["#{y}-#{y + 1}", year.to_s]
    end
  end
end
