$(document).ready(() => {
  $("#link").on("keyup", event => {
  
    const text = $("#link").val().trim();
    // console.log(text)
    
    const postParameters = {
                link: text};
    $.post("/resources/check_link", postParameters, responseJSON => {
              const responseObject = JSON.parse(responseJSON);
              if (responseObject) {
                $("#link_preview").html("<center><div class='embed-responsive embed-responsive-16by9 w-75'><iframe class='embed-responsive-item' style='border: 2px solid black' src=" + text + " allowfullscreen>Resource could not be rendered.</iframe> </div> </center>");
                
                // Displays 'Not Found' page if not a valid url.
              } else {
                $("#link_preview").html("<center><div class='embed-responsive embed-responsive-16by9 w-75'><iframe class='embed-responsive-item' style='border: 2px solid black' src='/not_found' allowfullscreen>Resource could not be rendered.</iframe> </div> </center>");
                }
                
    });
  });
  
  $("#text").on("keyup", event => {
    
    // TODO: Make text preview side-by-side with input and make text preview in box
  
    const text = $("#text").val();
    
    const postParameters = {
                text: text};
    $.post("/resources/parse_markdown", postParameters, responseJSON => {
              const responseObject = JSON.parse(JSON.stringify(responseJSON));
              // console.log(responseObject.html);
              if (responseObject.html) {
                $("#text_preview").html(responseObject.html);
                } 
              
                
    });
  });
  
  $("#video").on("keyup", event => {
  
    const text = $("#video").val().trim();
    // Take template for Youtube embed and only allow string after /embed/-------
    $("#video_preview").html("<iframe width='560' height='315' src='https://www.youtube.com/embed/" + text + "' frameborder='0' allow='accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture' allowfullscreen></iframe>");
    
    // <iframe width="560" height="315" src="https://www.youtube.com/embed/mniMgDtxUS0" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
    
  });
});

