require "test_helper"

class CampusLocationTest < ActiveSupport::TestCase
  test "requires a name" do
    campus_location = CampusLocation.new(address: "An address")

    assert_not campus_location.valid?
    assert_includes campus_location.errors[:name], "can't be blank"
  end

  test "requires a case-insensitively unique name" do
    CampusLocation.create!(name: "Keele", address: "First address")
    duplicate = CampusLocation.new(name: "keele", address: "Second address")

    assert_not duplicate.valid?
    assert_includes duplicate.errors[:name], "has already been taken"
  end
end
