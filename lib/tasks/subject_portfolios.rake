namespace :subject_portfolios do
  desc 'Report subject portfolio coverage and workflow anomalies without changing data'
  task audit: :environment do
    legacy_requests = TeachingRequest.where(subject_portfolio_id: nil)

    puts 'Subject portfolio audit'
    puts "Total teaching requests: #{TeachingRequest.count}"
    puts "Requests with a portfolio: #{TeachingRequest.where.not(subject_portfolio_id: nil).count}"
    puts "Requests without a portfolio: #{legacy_requests.count}"

    TeachingRequest.status.values.each do |status|
      count = legacy_requests.where(status: status.value).count
      puts "  Without portfolio - #{status.text}: #{count}"
    end

    missing_assignment_target = legacy_requests.where(
      status: TeachingRequest.status.in_process.value,
      lead_instructor_id: nil
    ).count

    puts "In-process requests with neither portfolio nor lead: #{missing_assignment_target}"
    puts "Portfolio requests awaiting a lead: #{TeachingRequest.awaiting_portfolio_lead.count}"
    portfolio_requests_with_lead = TeachingRequest
                                   .where.not(subject_portfolio_id: nil)
                                   .where.not(lead_instructor_id: nil)
                                   .count
    puts "Portfolio requests with a lead: #{portfolio_requests_with_lead}"
  end
end
