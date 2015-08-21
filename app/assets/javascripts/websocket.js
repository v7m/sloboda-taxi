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
  $(".dispatcher_index[data-orders-status='all'] #dispatcher_table > .order_" + order.id + " > .status").html(statusContent(order));
}

function removeOrderForDispatcher(order, status){
  $(".dispatcher_index[data-orders-status='" + status + "'] #dispatcher_table > .order_" + order.id).hide("slow", function(){
    $(this).remove();
  });
}


function addOrderForDispatcher(order, status){
  $(".dispatcher_index[data-orders-status='" + status + "'] #dispatcher_table").prepend(orderContent(order));
}

function changeStatusInAllForDriver(order){
  $(".driver_index[data-orders-status='all'] #driver_" + order.driver_id + "_table > .order_" + order.id + " > .status").html(statusContent(order));
}

function addOrderForDriver(order, status){
  $(".driver_index[data-orders-status='" + status + "'] #driver_" + order.driver_id + "_table").prepend(orderContent(order));
}

function removeOrderForDriver(order, status){
  $(".driver_index[data-orders-status='" + status + "'] #driver_" + order.driver_id + "_table > .order_" + order.id).hide("slow", function(){
    $(this).remove();
  });
}

channel.bind('new', function(order) {
  addOrderForDispatcher(order, "all");
  addOrderForDispatcher(order, "opened");
});

channel.bind('assign_driver', function(order) {
  addOrderForDriver(order, "all");
  addOrderForDriver(order, "pending");
  changeStatusInAllForDispatcher(order);
  removeOrderForDispatcher(order, "rejected");
  removeOrderForDispatcher(order, "opened");
  addOrderForDispatcher(order, "pending");
});

channel.bind('confirm', function(order) {
  changeStatusInAllForDispatcher(order);
  removeOrderForDispatcher(order, "pending");
  addOrderForDispatcher(order, "confirmed");
});

channel.bind('close', function(order) {
  changeStatusInAllForDispatcher(order);
  removeOrderForDispatcher(order, "confirmed");
  addOrderForDispatcher(order, "closed");
});

channel.bind('reject', function(order) {
  changeStatusInAllForDispatcher(order);
  removeOrderForDispatcher(order, "pending");
  removeOrderForDispatcher(order, "edited");
  addOrderForDispatcher(order, "rejected");
  removeOrderForDriver(order, "all");
  removeOrderForDriver(order, "pending");
  removeOrderForDriver(order, "edited");
});

channel.bind('change', function(order) {
  changeStatusInAllForDriver(order);
  removeOrderForDriver(order, "pending");
  removeOrderForDriver(order, "closed");
  addOrderForDriver(order, "edited");
  changeStatusInAllForDispatcher(order);
  removeOrderForDispatcher(order, "pending");
  removeOrderForDispatcher(order, "closed");
  addOrderForDispatcher(order, "edited");
});

channel.bind('accept_changes', function(order) {
  changeStatusInAllForDriver(order);
  removeOrderForDriver(order, "edited");
  addOrderForDriver(order, "pending");
  changeStatusInAllForDispatcher(order);
  removeOrderForDispatcher(order, "edited");
  addOrderForDispatcher(order, "pending");
});