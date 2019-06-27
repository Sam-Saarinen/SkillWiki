$(document).ready(() => {
  
  $("#create_resource").on('submit', event => {

    // Check if all of the content fields are empty.
    if (!$("#link").val() && !$("#video").val() && !$("#text").val()) {
      event.preventDefault();
      alert("At least one of the content boxes must be filled in");
      return false;
    }
  });
});