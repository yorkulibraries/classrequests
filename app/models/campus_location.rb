class CampusLocation < ApplicationRecord
   has_many :teaching_requests
   has_many :intro_library_researches

   validates :name, presence: true, uniqueness: { case_sensitive: false }
end
