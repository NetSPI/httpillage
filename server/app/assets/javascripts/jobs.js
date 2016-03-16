$(document).ready(function(){
    $('.jobs-table').DataTable();
    $(".job-response-code").each(function () {
      $(this).html(formatResponseCode($(this).html()));
    });
});