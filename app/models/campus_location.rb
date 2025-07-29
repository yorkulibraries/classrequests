class CampusLocation < ApplicationRecord
   has_many :teaching_requests
   has_many :intro_library_researches
end
