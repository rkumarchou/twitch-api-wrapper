$( document ).ready(function() {
  $("#search-twitcher").click(function(){
    let query = $("#query").val();
    if(query.trim()){
      $("#results").html('');
      $("#loading-results").show();
    }else{
      $("#loading-results").hide();
    }
  })
});
