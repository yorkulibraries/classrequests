class TeachingTypeOfInstruction < ApplicationRecord
  belongs_to :teaching_request
  belongs_to :type_of_instruction
end
