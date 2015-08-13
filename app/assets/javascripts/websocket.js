var dispatcher = new WebSocketRails('localhost:3000/websocket');
channel = dispatcher.subscribe('orders');
String.prototype.capitalizeFirstLetter = function() {
    return this.charAt(0).toUpperCase() + this.slice(1);
}

channel.bind('new', function(order) {
  $("#dispatcher_table").prepend(
    "<tr class='order_" + order.id + "'>" 
        + "<td class='show_button'>" 
            + "<form class='button_to' method='get' action='/orders/" + order.id + "'>"
                + "<input class='button tiny round info' type='submit' value='Show'>"
            + "</form>"
        + "</td>" 
        + "<td class='order_id'>" + order.id + "</td>"  
        + "<td class='departure'>" + order.departure + "</td>"
        + "<td class='destination'>" + order.destination + "</td>"
        + "<td class='car_type'>" + order.car_type.capitalizeFirstLetter() + "</td>"
        + "<td class='status'><b>" + order.status.capitalizeFirstLetter() + "</b></td>"
    + "<tr>");
});

channel.bind('assign_driver', function(order) {
    if( $("#driver_" + order.driver_id + "_table > .order_" + order.id).length) { 

        $("#driver_" + order.driver_id + "_table > .order_" + order.id + " > .status").html("<b>" + order.status.capitalizeFirstLetter() + "</b>");  
        
    } else {
       $("#driver_" + order.driver_id + "_table").prepend(
            "<tr class='order_" + order.id + "'>" 
                + "<td class='show_button'>" 
                    + "<form class='button_to' method='get' action='/orders/" + order.id + "'>"
                        + "<input class='button tiny round info' type='submit' value='Show'>"
                    + "</form>"
                + "</td>" 
                + "<td class='order_id'>" + order.id + "</td>"  
                + "<td class='departure'>" + order.departure + "</td>"
                + "<td class='destination'>" + order.destination + "</td>"
                + "<td class='car_type'>" + order.car_type.capitalizeFirstLetter() + "</td>"
                + "<td class='status'><b>" + order.status.capitalizeFirstLetter() + "</b></td>"
            + "<tr>");
    }     
});

channel.bind('confirm', function(order) {
  $("#dispatcher_table > .order_" + order.id + " > .status").html("<b>" + order.status.capitalizeFirstLetter() + "</b>");
});

channel.bind('close', function(order) {
  $("#dispatcher_table > .order_" + order.id + " > .status").html("<b>" + order.status.capitalizeFirstLetter() + "</b>");
});

channel.bind('reject', function(order) {
  $("#driver_" + order.driver_id + "_table > .order_" + order.id).hide("slow", function(){
    $(this).remove();
  });
});

channel.bind('change', function(order) {
  $("#dispatcher_table > .order_" + order.id + " > .status").html("<b>" + order.status.capitalizeFirstLetter() + "</b>");
});

channel.bind('accept_changes', function(order) {
  $("#driver_" + order.driver_id + "_table > .order_" + order.id + " > .status").html("<b>" + order.status.capitalizeFirstLetter() + "</b>");
});