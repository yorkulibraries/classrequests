require "application_system_test_case"

class SubjectPortfoliosTest < ApplicationSystemTestCase
  setup do
    @admin = create(
      :user,
      first_name: "Admin",
      last_name: "User",
      email: "portfolio-admin@example.com",
      is_active: true
    )
    create(:staff_profile, user: @admin, role: :administrator, is_approved: true)

    @member = create(
      :user,
      first_name: "Portfolio",
      last_name: "Member",
      email: "portfolio-member@example.com",
      is_active: true
    )
    create(:staff_profile, user: @member, role: :staff_instructor, is_approved: true)

    sign_in @admin
  end

  teardown do
    Warden.test_reset!
  end

  test "administrator manages a subject portfolio and its members" do
    visit staff_admin_subject_portfolios_path
    click_on "Add subject portfolio"

    fill_in "Name", with: "Humanities"
    fill_in "Notification email", with: "humanities@example.com"
    check "Available for assignment"
    click_on "Create subject portfolio"

    assert_text "Subject portfolio was successfully created."
    assert_selector "h1", text: "Humanities"

    member_label = [
      @member.full_name,
      @member.email,
      @member.staff_profile.role.text
    ].join(" | ")
    select member_label, from: "Staff member"
    click_on "Add member"

    assert_text "Portfolio member was successfully added."
    assert_selector "tr", text: @member.email

    find("button[aria-label='Remove #{@member.full_name} from this portfolio']").click
    within ".modal" do
      click_on "Confirm"
    end

    assert_text "Portfolio member was successfully removed."
    assert_no_selector "tr", text: @member.email

    click_on "All subject portfolios"
    portfolio = SubjectPortfolio.find_by!(name: "Humanities")
    within "##{ActionView::RecordIdentifier.dom_id(portfolio)}" do
      find("button[aria-label='Delete Humanities']").click
    end
    within ".modal" do
      click_on "Confirm"
    end

    assert_text "Subject portfolio was successfully deleted."
    assert_no_selector "##{ActionView::RecordIdentifier.dom_id(portfolio)}"
  end
end
