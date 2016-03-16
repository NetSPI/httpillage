$(document).ready(function () {
    var lastCheckinTimestamp = $("#current-time").val();

  $(".job-response").click(function () {
    $("#response-container").show();
    var responseId = $(this).data("id");

    // Make ajax request
    $.get("/job/response/" + responseId, function(data) {
      console.log(data.response);
      $("#response-id").text(responseId);
      $("#http-response").text(data.response);
    });

    $('html, body').animate({
        scrollTop: $(".job-responses").offset().top
    }, 200);
  });

  $(".job-flag").click(function () {
    $("#response-container").show();
    var flagId = $(this).data("id");

    // Make ajax request
    $.get("/job/response/fromMatch/" + flagId, function(data) {
      console.log(data.response);
      $("#response-id").text(flagId);
      $("#http-response").text(data.http_response);
    });

    $('html, body').animate({
        scrollTop: $(".job-responses").offset().top
    }, 200);

  });

  function formatResponseCode(code) {
    if(code == 0) {
      return '<span class="error-label">No Response</span>';
    } else if (/^2[0-9]{2}$/.test(code)) {
      return '<span class="success-label"><b>' + code + '</b></span>';
    } else if (/^3[0-9]{2}$/.test(code)) {
      return '<span class="success-label">' + code + '</span>';
    } else {
      return '<span class="error-label">' + code +'</span>';
    }
  }
  
if($("#attack-type").val() == "bruteforce") {
  // Poll for updated bruteforce status
  window.setInterval(function () {
    $.get('/job/' + $("#job-id").val() + '/progress', function(data) {
      $("#completion-percentage").text(data.keyspace_progress);
      $("#keyspace_start").text(data.keyspace_start);
      $("#keyspace_end").text(data.keyspace_end);
    });
  }, 1000)
}

  // Poll for updated node checkins
  window.setInterval(function () {
    $.get('/job/' + $("#job-id").val() + '/checkins/poll/' + lastCheckinTimestamp, function(data) {
      lastCheckinTimestamp = data.newTimestamp;

      for (idx in data.checkins) {
        row = data.checkins[idx];

        row.response_code = formatResponseCode(row.response_code);
        row = "<tr><td>" + row.node_id + "</td><td>" + row.response_code + "</td><td>" + row.created_at + "</td> </tr>";
        $(".node-checkins tbody").prepend(row);
      }

    // If there was data, delete place holder
    if (data.count > 0) {
      $("#node-checkin-row-placeholder").remove();
    }

    // Chop rows to 5.
    $(".node-checkins tbody").find("tr:gt(4)").remove();
    });
  }, 5000)

  // Poll for updated matches
  window.setInterval(function () {
    $.get('/job/response/' + $("#job-id").val() + '/poll/' + lastCheckinTimestamp, function(data) {
      lastCheckinTimestamp = data.newTimestamp;

      for (idx in data.matches) {
        row = data.matches[idx];

        row = "<tr><td>" + row.payload + "</td><td>" + row.matched_string + "</td><td>" + row.created_at + "</td> </tr>";
        $(".response-matches tbody").prepend(row);
      }

      // If there was data, delete place holder
      if (data.count > 0) {
        $("#response-matches-row-placeholder").remove();
      }

      // Chop rows to 5.
      $(".response-matches tbody").find("tr:gt(4)").remove();
    });
  }, 5000)

  $(".job-response-code").each(function () {
    $(this).html(formatResponseCode($(this).html()));
  });

});