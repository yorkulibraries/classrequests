/**
 * Purpose: Lookup/Select Course selection dropdown lists populator
 *
 **/

//Turbolinks 5.0+, we need to use :load instead of .ready
// $( document ).on('turbolinks:load', function() {
//  document.addEventListener('turbolinks:load', () => {
$(document).on('turbolinks:load', () => {

  // console.log( 'Lookup Courses JS!' );
  /**********************************************************************/
    // Listening to Academic Term Dropdown Change
    $('#teaching_request_academic_term').change(function() {
      const academic_term = $(this).val();

      // Reset the rest
      $('#teaching_request_academic_year').empty().trigger('chosen:updated');
      $('#teaching_request_faculty_abbrev').empty().trigger('chosen:updated');
      $('#teaching_request_subject_abbrev').empty().trigger('chosen:updated');

      fetchAcademicYears(academic_term);
    });

  /**********************************************************************/
    // Listening to Academic Year Dropdown change
    $('#teaching_request_academic_year').change(function() {
      const academic_year = $(this).val();
      const academic_term = $('#teaching_request_academic_term').val();

      $('#teaching_request_faculty_abbrev').trigger('chosen:updated');
      $('#teaching_request_subject_abbrev').trigger('chosen:updated');

      fetchFaculties(academic_term, academic_year);
    });

  /**********************************************************************/

    //Faculty Dropdown Change
    $('#teaching_request_faculty_abbrev').change(function() {
      const fac_abbrev = $(this).val();
      const academic_year = $('#teaching_request_academic_year').val();
      const academic_term = $('#teaching_request_academic_term').val();

      const selectedFacultyLabel = $(this).children('option:selected').text();
      const selectedFaculty = selectedFacultyLabel.split('-');
      $('#teaching_request_faculty').val($.trim(selectedFaculty[1]));

      fetchSubjects(fac_abbrev, academic_year, academic_term);

      $('#teaching_request_subject_abbrev').trigger('chosen:updated');
    });

  /**********************************************************************/
    //Subject Dropdown Change
    $('#teaching_request_subject_abbrev').change(function(){
      var subj_abbrev = $(this).val();
      var fac_abbrev = $('#teaching_request_faculty_abbrev').val();
      var academic_year = $('#teaching_request_academic_year').val();
      var selectedSubjectLabel = $(this).children('option:selected').text();
      var selectedSubject = selectedSubjectLabel.split('-');

      $('#teaching_request_subject').val($.trim(selectedSubject[1]));
    });

  /**********************************************************************/

    // COURSE TITLES
    //*** 2024 Update ***/
    $('#teaching_request_course_title').on('input', function(){
      var course_title_string = $(this).val();
      fetchCourseTitlesAuto(course_title_string);
    });

	/*************************** FUNCTIONS *******************************/

  // FETCH ACADEMIC YEARS FUNCTION
    const fetchAcademicYears = function(academic_term) {
      console.log('Fetching academic years for term: ' + academic_term);
      $.ajax({
        method: 'GET',
        // url: '/shared/fetch_libstar_data/?academic_term=' + academic_term,
        url: '/shared/fetch_libstar_data/?academic_term=' + encodeURIComponent(academic_term),
        dataType: 'json',
        success: function(data) {
          const target = $('select#teaching_request_academic_year');
          target.empty().append('<option></option>');

          $.each(data, function(i, model) {
            $(target).append(
              $('<option>', {
                value: model.academic_year,
                text: model.academic_year
              })
            );
          });

          target.trigger('chosen:updated');
        }
      });
    };

   // FETCH FACULTIES FUNCTION
    const fetchFaculties = function(academic_term, academic_year) {
      $.ajax({
        method: 'GET',
        // url: `/shared/fetch_libstar_data/?academic_term=${academic_term}&academic_year=${academic_year}`,
        url: `/shared/fetch_libstar_data/?academic_term=${encodeURIComponent(academic_term)}&academic_year=${encodeURIComponent(academic_year)}`,
        dataType: 'json',
        success: function(data) {
          const target = $('select#teaching_request_faculty_abbrev');
          target.empty().append('<option></option>');

          $.each(data, function(i, model) {
            $(target).append(
              $('<option>', {
                value: model.faculty_abbrev,
                text: model.faculty_abbrev + ' - ' + model.faculty
              })
            );
          });

          target.trigger('chosen:updated');
        }
      });
    }; // fetchFaculties

   // FETCH SUBJECTS FUNCTION
    const fetchSubjects = function(fac_abbrev, academic_year, academic_term) {
      $.ajax({
        method: 'GET',
        // url: `/shared/fetch_libstar_data/?faculty_name=${fac_abbrev}&academic_year=${academic_year}&academic_term=${academic_term}`,
        url: `/shared/fetch_libstar_data/?faculty_name=${encodeURIComponent(fac_abbrev)}&academic_year=${encodeURIComponent(academic_year)}&academic_term=${encodeURIComponent(academic_term)}`,
        dataType: 'json',
        success: function(data) {
          const target = $('select#teaching_request_subject_abbrev');
          target.empty().append('<option></option>');

          $.each(data, function(i, model) {
            $(target).append(
              $('<option>', {
                value: model.subject_abbrev,
                text: model.subject_abbrev + ' - ' + model.subject
              })
            );
          });

          target.trigger('chosen:updated');
        }
      });
    };// fetchSubjects
    
    //*** 2024 Update ***/
    function filterByTitles(titles) {
      $("#teaching_request_course_title").autocomplete({
         source: titles,
         autoFocus: true,
         minLength: 2
      });
    }

    var fetchCourseTitlesAuto = function(title_string){
      $.ajax({
        method: 'GET',
        url: '/shared/fetch_libstar_data/?course_title=' + title_string,
        dataType: 'json',
        success: function(response) {
          var target = $('#teaching_request_course_title');
          filterByTitles(response);
          // Trigger search to show suggestions immediately
          target.autocomplete('search', '');
        },
      });
    };

  /**********************************************************************/

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
