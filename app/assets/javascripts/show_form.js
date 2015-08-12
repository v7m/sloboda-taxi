$(document).ready(function() {
	$('body').on('click', '#show_main_form', function(e){
		e.preventDefault();
		if ($('#main_form').css('display') === 'none'){
			$('#main_form').slideDown(700);
		} else {
			$('#main_form').slideUp(500);
		}
	});
});	
