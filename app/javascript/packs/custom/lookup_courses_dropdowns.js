/**
 * Purpose: Lookup/Select Course selection dropdown lists populator
 *
 **/

//Turbolinks 5.0+, we need to use :load instead of .ready
// $( document ).on('turbolinks:load', function() {
$(document).on('turbolinks:load', () => {
// document.addEventListener('turbolinks:load', () => {

    // console.log( 'Lookup Courses JS!' );

    //Initial Load Reset the dropdowns
    // if $('#teaching_request_academic_year').val() == ''

    // $('#teaching_request_academic_year').val('option:first');
    // $('#teaching_request_faculty').empty();
    // $('#teaching_request_subject').empty();
    // $('#teaching_request_number_title_id').empty();

    if ($('#teaching_request_academic_year').val() != '') {
      var ay = $('#teaching_request_academic_year').val();
      // fetchFaculties(academic_year);
      // console.log('Acad. Year Not Empty: ' + ay );
      // fetchFaculties(academic_year);
      // console.log('Faculty' + $('#teaching_request_faculty_abbrev').val());
    }

  /**********************************************************************/
    // Listening to Academic Dropdown change
    $('#teaching_request_academic_year').change(function(){

      // If someone changes the academic year, reset all other dropdowns
      // $('#teaching_request_faculty_abbrev').empty();
      // $('#teaching_request_subject_abbrev').empty();
      $('select#teaching_request_faculty_abbrev').trigger('chosen:updated');
      $('select#teaching_request_subject_abbrev').trigger('chosen:updated');
      // $('#teaching_request_number_title_id').empty();

      // console.log('Academic Year Changed!');
      var academic_year = $(this).val();
      // console.log('Selected Year: ' + academic_year);
      fetchFaculties(academic_year);


    });

  /**********************************************************************/

    //Faculty Dropdown Change
    $('#teaching_request_faculty_abbrev').change(function(){


      $('#teaching_request_subject_abbrev').empty();
      // $('#teaching_request_number_title_id').empty();

      // console.log('Faculty was changed!');
      var fac_abbrev    = $(this).val();
      var academic_year = $('#teaching_request_academic_year').val();
      var selectedFacultyLabel = $(this).children('option:selected').text();
      var selectedFaculty = selectedFacultyLabel.split('-');
      // console.log('Faculty:#' + $.trim(selectedFaculty[1]) + '#');
      // console.log('Faculty ABBREV:' + $(this).val());

      $('#teaching_request_faculty').val($.trim(selectedFaculty[1]));
      fetchSubjects(fac_abbrev, academic_year);

      $('#teaching_request_subject_abbrev').trigger('chosen:updated');

    });

  /**********************************************************************/
    //Subject Dropdown Change
    $('#teaching_request_subject_abbrev').change(function(){
      // $('#teaching_request_number_title_id').empty();
      // console.log('Subject was changed!');
      var subj_abbrev = $(this).val();
      var fac_abbrev = $('#teaching_request_faculty_abbrev').val();
      var academic_year = $('#teaching_request_academic_year').val();
      var selectedSubjectLabel = $(this).children('option:selected').text();
      var selectedSubject = selectedSubjectLabel.split('-');

      $('#teaching_request_subject').val($.trim(selectedSubject[1]));
      // console.log(($(this).val()));
      // fetchCourseTitles(fac_abbrev, subj_abbrev, academic_year);
    });

  /**********************************************************************/

    // COURSE TITLES
    //*** 2024 Update ***/
    $('#teaching_request_course_title').on('input', function(){
      var course_title_string = $(this).val();
      fetchCourseTitlesAuto(course_title_string);
    });

	/*************************** FUNCTIONS *******************************/

   // FETCH FACULTIES FUNCTION
    var fetchFaculties = function(academic_year){
      console.log('I am fetching Faculties for ' + academic_year);
      $.ajax({
        method: 'GET',
        // url: '/patrons/lookup_courses/?academic_year=' + academic_year,
        url: '/shared/fetch_libstar_data/?academic_year=' + academic_year,
        dataType: 'json',
        success: function(data) {
          // console.log('SUCCESS OF ACADEMIC YEAR!!!');
          // console.log(data[0]);

          // field to which options will be appended to.
          var target = $('select#teaching_request_faculty_abbrev');

          target.empty();
          // $(target).append('<option>Select a Faculty</option>');
          $(target).append('<option></option>');

          $.each(data, function(id, model) {
            // console.log(data)
            $(target).append(
              // $('<option>').text(model).attr('subject', id) // populate options
              $('<option>', {
                value: model.faculty_abbrev,
                text: model.faculty_abbrev + ' - ' + model.faculty
              }, '</option>')
            );
          });
          $('select#teaching_request_faculty_abbrev').trigger('chosen:updated');
        }

      }); //ajax-close
    } // fetchFaculties

   // FETCH SUBJECTS FUNCTION
    var fetchSubjects = function(fac_abbrev, academic_year){
      // console.log('I am fetching Subjects AJAX ' + fac_abbrev + ' for ' + academic_year);
      $.ajax({
        method: 'GET',
        url: '/shared/fetch_libstar_data/?faculty_name=' + fac_abbrev + '&academic_year=' + academic_year,
        dataType: 'json',
        success: function(data) {
          // console.log('SUCCESS OF SUBJECTS!!!');
          // console.log(data[0]);

          // field to which options will be appended to.
          var target = $('select#teaching_request_subject_abbrev');
          target.empty();
          // $(target).append('<option>Select a Subject/Dept</option>');
          $(target).append('<option></option>');

          $.each(data, function(id, model) {
            // console.log(data)
            $(target).append(
              // $('<option>').text(model).attr('subject', id) // populate options
              $('<option>', {
                value: model.subject_abbrev,
                text: model.subject_abbrev + ' - ' + model.subject
              }, '</option>')
            );
          });
          $('select#teaching_request_subject_abbrev').trigger('chosen:updated');
        }

      }); //ajax-close
    } // fetchSubjects
    
    //*** 2024 Update ***/
    function filterByTitles(titles) {
      $("#teaching_request_course_title").autocomplete({
         source: titles,
         autoFocus: true,
         minLength: 2
      });
    }

    var fetchCourseTitlesAuto = function(title_string){
      // console.log('Fetching Course Titles for ' + title_string);
      $.ajax({
        method: 'GET',
        url: '/shared/fetch_libstar_data/?course_title=' + title_string,
        dataType: 'json',
        success: function(response) {
          // Log the entire response as a string
          // console.log('Response Data (stringified): ', JSON.stringify(response));
          // console.log('RESPONSE: ', response)
          var target = $('#teaching_request_course_title');
          filterByTitles(response);
          // Trigger search to show suggestions immediately
          target.autocomplete('search', '');
        },
        // error: function(xhr, status, error) {
        //   console.error('Error fetching course titles:', status, error);
        // }
      });
    };

  /**********************************************************************/
     /** DO NOT REMEMBER WHY I WROTE THE LOCATION FUNCTION. WILL LOOK INTO ****/

     $('#location_campus').change(function(){
       $('#session_location').empty();
       var campus_id = $(this).val();
       console.log('Campus-ID:' + $(this).val());
       fetchLocations(campus_id);

     });
     var fetchLocations = function(campus_id){
       console.log('I am fetching Locations AJAX');
       $.ajax({
         method: 'GET',
         url:'./?campus_id=' + campus_id,
         dataType: 'json',
         success: function(data) {

           console.log('I SUCCESSFULLY made it to Fetch Locations');
           console.log(data[0]);
           var target = $('select#session_location');  // field to which options are appended
           target.empty(); // Clear the dropdown
           $(target).append('<option>Select Location</option>'); //Add empty row.
           $.each(data, function(id, model){
             $(target).append(
               $('<option>', {
                 value: model.id,
                 text: model.name
               }, '</option>')
             );
           }); // each end
         }
       }); //ajax-close
      } // fetchLocation-close

});
