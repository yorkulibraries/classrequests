require "application_system_test_case"

class UjsTest < ApplicationSystemTestCase
  setup do
    @patron = FactoryBot.create(:valid_patron)
    sign_in(@patron)
  end

  teardown do
    Warden.test_reset!
  end

  test "rails ujs opens custom data-confirm modal" do
    visit root_url

    page.execute_script(<<~JS)
      var link = document.createElement("a");
      link.href = "#";
      link.id = "ujs-confirm-probe";
      link.setAttribute("data-confirm", "Are you sure?");
      link.textContent = "UJS Confirm Probe";
      document.body.appendChild(link);
    JS

    click_link "UJS Confirm Probe"

    assert_selector ".modal", text: "Are you sure?", visible: true
    assert_selector ".modal .commit", text: "Confirm", visible: true
    assert_selector ".modal .cancel", text: "Cancel", visible: true
  end
end