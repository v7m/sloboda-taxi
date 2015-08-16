var dispatcher = new WebSocketRails(window.location.host + '/websocket');
channel = dispatcher.subscribe('orders');

String.prototype.capitalizeFirstLetter = function() {
  return this.charAt(0).toUpperCase() + this.slice(1);
}

function orderContent(order) { 
  return  "<tr class='order_" + order.id + "'>" 
        + "<td class='show_button'>" 
            + "<a class='button tiny round info show_order' role='button' data-method='get' href='/orders/" + order.id + "'>Show</a>"
        + "</td>" 
        + "<td class='order_id'>" + order.id + "</td>"  
        + "<td class='departure'>" + order.departure + "</td>"
        + "<td class='destination'>" + order.destination + "</td>"
        + "<td class='car_type'>" + order.car_type.capitalizeFirstLetter() + "</td>"
        + "<td class='status'><b>" + order.status.capitalizeFirstLetter() + "</b></td>"
    + "<tr>";
}

function statusContent(order) {
  return "<b>" + order.status.capitalizeFirstLetter() + "</b>"
}

function changeStatusInAllForDispatcher(order){
  return $(".dispatcher_index[data-orders-status='all'] #dispatcher_table > .order_" + order.id + " > .status").html(statusContent(order));
}

function removeOrderForDispatcher(order, status){
  return $(".dispatcher_index[data-orders-status='" + status + "'] #dispatcher_table > .order_" + order.id).hide("slow", function(){
        $(this).remove();
      });
}

function addOrderToDispatcher(order, status){
  return $(".dispatcher_index[data-orders-status='" + status + "'] #dispatcher_table").prepend(orderContent(order))
}

channel.bind('new', function(order) {
  addOrderToDispatcher(order, "all");
  addOrderToDispatcher(order, "opened");
});

channel.bind('assign_driver', function(order) {
    if( $("#driver_" + order.driver_id + "_table > .order_" + order.id).length) { 

        $("#driver_" + order.driver_id + "_table > .order_" + order.id + " > .status").html(statusContent(order));  
        
    } else {
       $("#driver_" + order.driver_id + "_table").prepend(orderContent(order));
    }

    changeStatusInAllForDispatcher(order);
    removeOrderForDispatcher(order, "opened");
    addOrderToDispatcher(order, "pending");
});

channel.bind('confirm', function(order) {
  changeStatusInAllForDispatcher(order);
  removeOrderForDispatcher(order, "pending");
  addOrderToDispatcher(order, "confirmed");
});

channel.bind('close', function(order) {
  changeStatusInAllForDispatcher(order);
  removeOrderForDispatcher(order, "confirmed");
  addOrderToDispatcher(order, "closed");
});

channel.bind('reject', function(order) {
  $("#driver_" + order.driver_id + "_table > .order_" + order.id).hide("slow", function(){
    $(this).remove();
  });
});

channel.bind('change', function(order) {
  changeStatusInAllForDispatcher(order);
  removeOrderForDispatcher(order, "pending");
  removeOrderForDispatcher(order, "closed");
  addOrderToDispatcher(order, "edited");
});

channel.bind('accept_changes', function(order) {
  $("#driver_" + order.driver_id + "_table > .order_" + order.id + " > .status").html(statusContent(order));
});