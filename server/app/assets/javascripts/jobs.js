$(document).ready(function(){
    $('.dictionaries-table').DataTable();
    $(".job-response-code").each(function () {
      $(this).html(formatResponseCode($(this).html()));
    });
});