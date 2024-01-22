
# TEST PLAN
## Scope

* Unit Tests
* System Tests
  
## Test List

* **User**
  * Request a Teaching Class
  * Dashboard
  * Cancel Request
<br/>

* **Manager**
  * Requests Dashboard
  * Assign Request
  * Manager Dashboard
  * Approve New Staff
  * Submit TR Manually
  * Reports 
<br/>

* **Staff**
  * Respond to Assignment
  * Submit TR Manually
  * Dashboard
    * Assigned
    * My TRs
    * Recently Completed
  * Reports
<br/>

* **Admin**
  * Dashboard
  * Approve Users
  * Delete users
  * App Settings


* **UPGRADING NOTES**
Node 16+ info.
You will get an error on webpacker compile for anything higher than node 16.
Workaround for now:
export NODE_OPTIONS=--openssl-legacy-provider
bundle exec rails assets:precompile RAILS_ENV=test
bundle exec rails test:system


* **TESTING**
1. docker-compose up
2. another terminal:  docker-compose exec -e SELENIUM_REMOTE_HOST=chrome-server classreq_test2 bash
3. bundle exec rails test:system OR
4. Run Specific System Test: bundle exec rails test test/system/teaching_requests_test.rb





<!-- Current url check -->
assert_current_path post_path(Post.last) 


assert page.has_content?('Test Title')
assert page.has_content?('Test Body')

<!-- Test mailing -->
test 'writing a new post sends admin notice' do
    perform_enqueued_jobs do
        write_new_post

        last_post = Post.last
        mail      = ActionMailer::Base.deliveries.last

        assert_equal 'admin@example.com', mail['to'].to_s
        assert_equal 'New post added', mail.subject
    end
end