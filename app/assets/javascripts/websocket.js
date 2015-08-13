var dispatcher = new WebSocketRails('localhost:3000/websocket');
channel = dispatcher.subscribe('orders');
String.prototype.capitalizeFirstLetter = function() {
    return this.charAt(0).toUpperCase() + this.slice(1);
}
channel.bind('new', function(order) {
  $("#dispatcher_table").prepend(
    "<tr>" 
        + "<td>" 
            + "<form class='button_to' method='get' action='/orders/" + order.id + "'>"
                + "<input class='button tiny round info' type='submit' value='Show'>"
            + "</form>"
        + "</td>" 
        + "<td>" + order.id + "</td>"  
        + "<td>" + order.departure + "</td>"
        + "<td>" + order.destination + "</td>"
        + "<td>" + order.car_type.capitalizeFirstLetter() + "</td>"
        + "<td><b>" + order.status.capitalizeFirstLetter() + "</b></td>"
    + "<tr>");
  // debugger;
    
})