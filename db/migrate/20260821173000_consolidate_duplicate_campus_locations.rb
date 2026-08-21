class ConsolidateDuplicateCampusLocations < ActiveRecord::Migration[7.2]
  class MigrationCampusLocation < ActiveRecord::Base
    self.table_name = "campus_locations"
  end

  class MigrationTeachingRequest < ActiveRecord::Base
    self.table_name = "teaching_requests"
  end

  class MigrationIntroLibraryResearch < ActiveRecord::Base
    self.table_name = "intro_library_researches"
  end

  def up
    canonical_ids_by_name = {}

    MigrationCampusLocation.order(:id).find_each do |campus_location|
      normalized_name = campus_location.name.to_s.downcase
      canonical_id = canonical_ids_by_name[normalized_name]

      if canonical_id
        MigrationTeachingRequest
          .where(campus_location_id: campus_location.id)
          .update_all(campus_location_id: canonical_id)
        MigrationIntroLibraryResearch
          .where(campus_location_id: campus_location.id)
          .update_all(campus_location_id: canonical_id)
        campus_location.delete
      else
        canonical_ids_by_name[normalized_name] = campus_location.id
      end
    end

    add_index :campus_locations, :name, unique: true
  end

  def down
    remove_index :campus_locations, :name
  end
end
