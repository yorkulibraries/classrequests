require "test_helper"

class CancelRequestTest < ActiveSupport::TestCase
  setup do
    @teaching_request = create(:default_teaching_request)
    @cancel_request = CancelRequest.new(
      teaching_request: @teaching_request,
      user: @teaching_request.user,
      reason: "The class is no longer running."
    )
  end

  test "requires a cancellation reason" do
    @cancel_request.reason = ""

    assert_not @cancel_request.valid?
    assert_includes @cancel_request.errors[:reason], "can't be blank"
  end

  test "is processed when the teaching request is cancelled" do
    assert_not @cancel_request.processed?

    @teaching_request.status = :cancelled

    assert @cancel_request.processed?
    assert @cancel_request.cancelled?
    assert_not @cancel_request.deleted?
  end

  test "is processed when the teaching request is deleted" do
    @teaching_request.status = :deleted

    assert @cancel_request.processed?
    assert @cancel_request.deleted?
    assert_not @cancel_request.cancelled?
  end
end
