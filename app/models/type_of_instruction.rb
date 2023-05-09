class TypeOfInstruction < ApplicationRecord
    has_many :teaching_type_of_instructions, dependent: :destroy
    has_many :teaching_requests, through: :teaching_type_of_instructions
end
