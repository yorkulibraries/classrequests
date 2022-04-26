$(document).on('turbolinks:load', () => {

  $('#menu-toggle').click(function(e) {
    e.preventDefault();
    $('#wrapper').toggleClass('toggled');

    // When user toggles the menu, close any submenus in the sidebar
    $('#wrapper #sidebar-wrapper .show').removeClass('show');
  });
  $('#inner-menu-toggle').click(function(e) {
    e.preventDefault();
    $('#wrapper').toggleClass('toggled');

    // When user toggles the menu, close any submenus in the sidebar
    $('#wrapper #sidebar-wrapper .show').removeClass('show');
  });


  /* COMPACT SIDEBAR ACTIONS *
   * If sidebar is collapsed, and user clicks on
   * sidebar-item that has a submenu, then expand the sidebar/un-collapse
   * it and show the submenu
   */
  // $('#wrapper .sidebar-items .nav-link[data-bs-toggle="collapse"]').on('click', function() {
  //   $("#wrapper").removeClass("toggled");
  // });
  // $('#wrapper.toggled .sidebar-items .nav-link[data-bs-toggle="collapse"]').on('click', function() {
  //   $("#wrapper").removeClass("toggled");
  // });
  // $('#wrapper .sidebar-close .nav-link[data-bs-toggle="collapse"]').on('click', function() {
  //   $("#wrapper").removeClass("toggled");
  // });


  // $("#sidebar").mCustomScrollbar({
  //   theme: "minimal"
  // });


});
