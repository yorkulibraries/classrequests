require 'test_helper'

class SubjectPortfoliosHelperTest < ActionView::TestCase
  include SubjectPortfoliosHelper

  test 'confirmed assignments use the positive badge color' do
    badge = lead_assignment_state_badge_for(request_with_state(:confirmed_without_response))
    element = Nokogiri::HTML.fragment(badge).at_css('span.badge.bg-success')

    assert element
    assert_equal 'confirmed_without_response', element['data-lead-assignment-state']
  end

  test 'missing lead responses use the attention badge color' do
    badge = lead_assignment_state_badge_for(request_with_state(:no_response_recorded))
    element = Nokogiri::HTML.fragment(badge).at_css('span.badge.bg-danger')

    assert element
    assert_equal 'no_response_recorded', element['data-lead-assignment-state']
  end

  private

  def request_with_state(state)
    Struct.new(:lead_assignment_state).new(state)
  end
end
