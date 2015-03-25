#
# deletePost handles deleting records
#
# dependencies:
#   sweetalert
#
#   data-url="", data-id="" - eg.

closeSweetAlert = () ->
  try
    swal.close()
  catch error
    $('.sweet-overlay').hide()
    $('.sweet-alert').hide()


@deletePost = ($elem) ->
  try
    url = $elem.data('url') + "/" + $elem.data('id') + ".js"
    $remove = $($elem.data('remove'))
    request = $.ajax
      url: url,
      type: "delete",
      statusCode:
        200: (response,textStatus,jqXHR) ->
          if $remove
            $remove.hide()
          closeSweetAlert()
          $('.message_container').html(response.responseText)

        301: () ->
          $elem.show()
          closeSweetAlert()
          swal "Ikke slettet!", "Posten blev ikke slettet - årsagen ikke kendt", "warning"

        401: () ->
          $elem.show()
          closeSweetAlert()
          swal "Øv!", "Et eller andet gik galt!", "error"

  catch error
    swal "Hmmm", "#{error}", "error"
