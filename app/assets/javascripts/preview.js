$(document).ready(() => {
  $("#resource_link").on("keyup", event => {
  
    const text = $("#resource_link").val();
    // console.log(text)
    
    const postParameters = {
                link: text};
    $.post("/resources/check_link", postParameters, responseJSON => {
              const responseObject = JSON.parse(responseJSON);
              // console.log("--- " + responseObject + " ---");
              if (responseObject) {
                $("#link_preview").html("<center><div class='embed-responsive embed-responsive-16by9 w-75'><iframe class='embed-responsive-item' style='border: 2px solid black' src=" + text + " allowfullscreen>Resource could not be rendered.</iframe> </div> </center>");
                } 
              // Could add a "Link Not Found!" page if not a valid url. Always refresh to Link Not Found page if not a valid url.
                
    });
  });
  
  $("#resource_text").on("keyup", event => {
    
    // TOOD: Make text preview side-by-side with input and make text preview in 
  
    const text = $("#resource_text").val();
    // console.log(text)
    
    const postParameters = {
                text: text};
    $.post("/resources/parse_markdown", postParameters, responseJSON => {
              // console.log("--- " + responseJSON + " ---");
              const responseObject = JSON.parse(JSON.stringify(responseJSON));
              // console.log("--- " + responseObject + " ---");
              if (responseObject.html) {
                $("#text_preview").html(responseObject.html);
                } 
              
                
    });
  });
  
  $("#resource_video").on("keyup", event => {
  
    const text = $("#resource_video").val();
    // Take template for Youtube embed and only allow string after /embed/-------
    $("#video_preview").html(text);
    
    
  });
});

