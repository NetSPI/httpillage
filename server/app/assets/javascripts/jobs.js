$(document).ready(function(){
  $('.jobs-table').DataTable();

  var clicked = 100;
  $("#addNewFlag").click(function () {
    clicked++;
    row = '<input class="input-field inline" type="text" name="job[response_flag_meta][' + clicked + '][match_value]" style="display:inline"><select name="job[response_flag_meta][' + clicked + '][match_type]" class="inline"><option value="string">String</option><option value="regex">Regex</option></select><select name="job[response_flag_meta][' + clicked + '][match_delivery]" class="inline"><option value="instant">Instant Delivery</option><option value="batch">Batched Delivery</option></select><br />';

      $("#response_flags").append(row);
      return false;
  });
    
  $("#job_attack_type").change(function () {
    var attack_type = $(this).val();
    
    if(attack_type == "dictionary") { 
      $("#dictionary").removeClass("hidden");
      $("#charset").addClass("hidden");
    } else if(attack_type == "bruteforce") {
      $("#charset").removeClass("hidden");
      $("#dictionary").addClass("hidden");
    } else {
      $("#charset").addClass("hidden");
      $("#dictionary").addClass("hidden");
    }
  });
});
