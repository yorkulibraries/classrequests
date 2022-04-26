// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from '@rails/ujs'
import Turbolinks from 'turbolinks'
import * as ActiveStorage from '@rails/activestorage'
import 'channels'


Rails.start()
Turbolinks.start()
ActiveStorage.start()
require('jquery')
//jquery-ui-dist@1.12.1
require('jquery-ui')
// require('jquery-ui-dist/jquery-ui.css');
// require('jquery-ui-dist/jquery-ui.theme.css');
// require('jquery-ui-bundle');


// import * from 'packs/custom/custom-dialog'

import flatpickr from 'flatpickr'
// require ('flatpickr/dist/flatpickr.css') //flatpickr css
require ('flatpickr/dist/themes/material_red.css') //flatpickr css

import $ from 'jquery';
import * as bootstrap from 'bootstrap';
global.$ = global.jQuery = jQuery;
window.$ = window.jQuery = jQuery;

require('packs/custom/sidebar')
require('packs/custom/custom-dialog')
// import '../stylesheets/application';
// window.jQuery = $;
// window.$ = $;

require('chosen-js')
/* working chosen if webpacker *
import chosen from 'chosen-js'

import 'chosen-js/chosen.css'
import '../stylesheets/chosen-bootstrap-libstar';
*************** */

$(document).on('turbolinks:load', () => {
  $('.request-chosen').chosen({
    no_results_text: 'No Result Found',
    width: '100%',
    allow_single_deselect:true
  });

  // hide by default
  $('.behalf_row').hide();
  $('#teaching_request_patron_type').change(function() {
    if ($('#teaching_request_patron_type').val() == 'Librarian / Archivist' ||
        $('#teaching_request_patron_type').val() == 'Other' ) {
      $('.behalf_row').show();
    }
    else
      $('.behalf_row').hide();

  });

  //Bootstrap Alerts to fade after 5 seconds -- for turbolinks v5
  $('.alert').delay(5000).fadeOut(500, function(){
    $('.alert').alert('close');
  });

  // FLATPICKR FOR DATE AND TIME
  // https://flatpickr.js.org/examples/#flatpickr-external-elements

  flatpickr("[data-behaviour='flatpickr-teaching-request']", {
    altInput: true,
    altFormat: 'F j, Y',
    // dateFormat: 'Y-m-d',
    // formatDate: 'Y-m-d',
    //   minDate: 'today',
    shorthandCurrentMonth: true
  });

  flatpickr("[data-behaviour='flatpickr-date']", {
    altInput: true,
    altFormat: 'F j, Y',
    // dateFormat: "Y-m-d",
    // formatDate: 'Y-m-d',
    shorthandCurrentMonth: true
  });

  flatpickr("[data-behaviour='flatpickr-time']", {
    enableTime: true,
    noCalendar: true,
    dateFormat: 'H:i',
    minTime: '8:00',
    maxTime: '19:30',
    minuteIncrement: 30
    // time_24hr:
  });

  flatpickr("[data-behaviour='flatpickr-datetime']", {
    enableTime: true,
    dateFormat: 'Y-m-d H:i'
  });

});

window.addEventListener('DOMContentLoaded', () => {

  //$ jquery does not work in here
  // $('.request-chosen').chosen({
  //   no_results_text: 'No Result Found',
  //   width: '100%'
  // });
})
require('packs/custom/lookup_courses_dropdowns')


// FOR BOOTSTRAP 5
document.addEventListener('DOMContentLoaded', function(event) {
  var popoverTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="popover"]'))
  var popoverList = popoverTriggerList.map(function (popoverTriggerEl) {
    return new bootstrap.Popover(popoverTriggerEl)
  })

  var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
  var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
    return new bootstrap.Tooltip(tooltipTriggerEl)
  })

});

document.addEventListener('turbolinks:load', () => {

});


// jQuery(document).ready(function($){
//   $('.request-chosen').chosen({
//     no_results_text: 'No Result Found',
//     width: '100%',
//     allow_single_deselect:true
//   });
//
//   // Plain jquery
//   $('#fadeMe').fadeOut(5000);
//
// });

// $(function(){})
import 'packs/custom/trix-editor-overrides'
require('trix')
require('@rails/actiontext')
