require "test_helper"

class AssignmentResponseTest < ActiveSupport::TestCase

  should belong_to(:teaching_request)
  should belong_to(:user)
end
