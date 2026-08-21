require "test_helper"

class SubjectPortfolioDeclineTest < ActiveSupport::TestCase
  should belong_to(:teaching_request)
  should belong_to(:subject_portfolio)
  should belong_to(:declined_by).class_name("User")

  should validate_presence_of(:reason)

  test "limits the return reason length" do
    decline = build(:subject_portfolio_decline, reason: "x" * 2_001)

    assert_not decline.valid?
    assert_includes decline.errors[:reason], "is too long (maximum is 2000 characters)"
  end
end
