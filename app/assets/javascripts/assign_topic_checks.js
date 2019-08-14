$(document).ready(() => {
  $("#assign_topic").on('submit', event => {
  
      // Prevents form submit so that post request below finish before 
      // form submit
      event.preventDefault();
      
      // Check if all of the checkboxes are empty.
      none = $("input:checkbox:checked").length === 0;
      if (none) {
        alert("At least one student must be assigned the topic");
        return false;
      }
      
      $("#assign_topic").off().submit();  
      
      // Begin check for duplicate assignments
      // const checkboxes = $('[name^="students"]:checked')
      // students = []
      // for (let i=0; i < checkboxes.length; i++) {
      //   students.push($(checkboxes[i]).prop('id'));
      // }

      // const postParameters = {
      //             classroom_id: $("#classroom_id").val(),
      //             topic_id: $("#topic_id").val(),
      //             checked: students};
      
      // $.post("/assignments/dup_assignments", postParameters, responseJSON => {
      //     const responseObject = JSON.parse(responseJSON);
          
      //     if (responseObject) {
      //       alert("Assignment already exists for ...");
      //     } else {
      //       // off() makes sure no infinite loop
      //       $("#assign_topic").off().submit();  
      //     }
                  
      // });
      // return false;
    });
});