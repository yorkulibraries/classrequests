/**
 * Purpose: Lookup/Select Course selection dropdown lists populator
 *
 **/

//Turbolinks 5.0+, we need to use :load instead of .ready
// $( document ).on('turbolinks:load', function() {
$(document).on('turbolinks:load', () => {
// document.addEventListener('turbolinks:load', () => {

    console.log( 'Lookup Courses JS!' );

    //Initial Load Reset the dropdowns
    // if $('#teaching_request_academic_year').val() == ''

    // $('#teaching_request_academic_year').val('option:first');
    // $('#teaching_request_faculty').empty();
    // $('#teaching_request_subject').empty();
    // $('#teaching_request_number_title_id').empty();

    if ($('#teaching_request_academic_year').val() != '') {
      var ay = $('#teaching_request_academic_year').val();
      // fetchFaculties(academic_year);
      console.log('Acad. Year Not Empty: ' + ay );
      // fetchFaculties(academic_year);
      console.log('Faculty' + $('#teaching_request_faculty_abbrev').val());
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

      console.log('Academic Year Changed!');
      var academic_year = $(this).val();
      console.log('Selected Year: ' + academic_year);
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
      console.log(($(this).val()));
      // fetchCourseTitles(fac_abbrev, subj_abbrev, academic_year);
    });

  /**********************************************************************/

    // COURSE TITLES
    // $('#teaching_request_number_title').change(function(){
    //   $('#teaching_request_institute_course_id').empty();
    //   console.log('Course/Section was changed!');
    //   var course_id = $(this).val();
    //   console.log(($(this).val()));
    //   $('#teaching_request_institute_course_id').val($(this).val());
    // });

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
          console.log('SUCCESS OF ACADEMIC YEAR!!!');
          console.log(data[0]);

          // field to which options will be appended to.
          var target = $('select#teaching_request_faculty_abbrev');

          target.empty();
          // $(target).append('<option>Select a Faculty</option>');
          $(target).append('<option></option>');

          $.each(data, function(id, model) {
            // console.log(data)

            // if (model.faculty.length > 40) {
            //   faculty_full = model.faculty.substring(0, 40) + ' ...';
            // }else {
            //   faculty_full = model.faculty;
            // }

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
      console.log('I am fetching Subjects AJAX ' + fac_abbrev + ' for ' + academic_year);
      $.ajax({
        method: 'GET',
        // url: '/patrons/lookup_courses/?faculty_name=' + fac_abbrev + '&academic_year=' + academic_year,
        url: '/shared/fetch_libstar_data/?faculty_name=' + fac_abbrev + '&academic_year=' + academic_year,
        dataType: 'json',
        success: function(data) {
          console.log('SUCCESS OF SUBJECTS!!!');
          // console.log(data[0]);

          // field to which options will be appended to.
          var target = $('select#teaching_request_subject_abbrev');
          // var target = $('select#teaching_request_subject_chosen');

          target.empty();
          // $(target).append('<option>Select a Subject/Dept</option>');
          $(target).append('<option></option>');

          $.each(data, function(id, model) {
            // console.log(data)

            // if (model.subject.length > 40) {
            //   subject_full = model.subject.substring(0, 40) + ' ...';
            // }else {
            //   subject_full = model.subject;
            // }

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

   // FETCH COURSE NUMBER/TITLES
    var fetchCourseTitles = function(fac_abbrev, subj_abbrev, academic_year){
      // console.log('I am fetching Subjects AJAX');
      $.ajax({
        method: 'GET',
        // url:'/patrons/lookup_courses/?subject_name=' + subj_abbrev + '&faculty_name=' + fac_abbrev + '&academic_year=' + academic_year,
        url:'/shared/fetch_libstar_data/?subject_name=' + subj_abbrev + '&faculty_name=' + fac_abbrev + '&academic_year=' + academic_year,
        dataType: 'json',
        success: function(data) {

          console.log('I SUCCESSFULLY made it to Course Titles!!!');
          console.log(data[0]);
          var character_padding = ''
          var target = $('select#teaching_request_number_title_id');  // field to which options are appended
          target.empty(); // Clear the dropdown
          // $(target).append('<option>Select Course Number</option>');
          $(target).append('<option></option>'); //Add empty row.
          $.each(data, function(id, model){
            if (model.title == null) {
              model.title = ''
            }

            if (model.title.length > 40 ) {
              course_title_full = model.title.substring(0, 40) + ' ...';
            }else {
              course_title_full = model.title;
            }
            if (model.academic_term.length == 1) {
              character_padding = ' - '
              console.log(model.academic_term + ':' + model.academic_term.length)
            }

            $(target).append(
              $('<option>', {
                value: model.id,
                text: model.number + ' - ' + ' [' + model.credits + '.00]'
                // text: model.academic_term + character_padding + ' \t ' + ' ' + model.number + ' - '  + ' ' + course_title_full + ' [' + model.credits + '.00]'

              }, '</option>')
            );
          }); // each end
          //'\u2022' + ' ' +

         $('select#teaching_request_number_title_id').trigger('chosen:updated');
        } // success end

      }); //ajax-close
    } // fetchCourseTitles


  /**********************************************************************/













     /** VERIFY IF STILL NEEDED ****/

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


      /***** CHOSEN PLUGIN *****/

      // $('.request-chosen').chosen({
      //   no_results_text: 'No Result Found',
      //   width: '100%'
      // });

      // $('#teaching_request_faculty').chosen({
      //   no_results_text: 'No Result Found',
      //   width: '100%'
      // });


});
