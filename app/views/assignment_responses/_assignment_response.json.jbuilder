json.extract! assignment_response, :id, :response, :comment_or_reason, :teaching_request_id, :user_id, :created_at, :updated_at
json.url assignment_response_url(assignment_response, format: :json)
