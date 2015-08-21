$(document).ready(function() {
  $('body').on('click', '.show_orders', function(e){
    e.preventDefault();
    if ($('#orders_table').css('display') === 'none'){
      $('#orders_table').slideDown(500);
    } else {
      $('#orders_table').slideUp(500);
    }
  });
}); 