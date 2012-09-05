$(function() {
  $("#div_update th a, #div_update .pagination a").live("click", function() {
    $.getScript(this.href);
    return false;
  });
  $("#div_update_search input").keyup(function() {
    $.get($("#div_update_search").attr("action"), $("#div_update_search").serialize(), null, "script");
    return false;
  });
});
