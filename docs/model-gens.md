# LIBSTAR MODEL DOCS

### Create User::RequestStaffAccount Controller for users requesting to be upgraded from user -> staff
1. User::Request Staff Access - Done
2. Notify Admins - Skip for now
3. Admin::Approve Staff
4. Notify Staff
5. Admin has CRUD functionality

`` rails g controller user/request_staff_account new create ``



rails g scaffold TeachingRequest username:string patron_type:integer first_name:string last_name:string email:string phone:string academic_year:string faculty:string faculty_abbrev:string subject:string subject_abbrev:string course_title:string course_number:integer submitted_by:string submitted_on_behalf:string section_name_or_about:string number_of_students:integer preferred_date:date preferred_time:time alternate_date:date alternate_time:time duration:string location_preference:string lead_instructor_id:integer second_instructor_id:integer third_instructor_id:integer status:string request_note:text instructor_notes:text


rails g controller Staff::Manager::AssignRequestLead edit update

rails g controller Staff::LeadAssignmentResponse edit update

rails g scaffold Staff::AssignmentResponse response:string comment_or_reason:text teaching_request:references user:references

rails g model CancelRequest user:references request:references reason:text  

rails g controller User::CancelRequests new create
