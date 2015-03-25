#
# initializeSweetAlert
# initializes the sweetalert prompt
#
@initializeSweetAlert = () ->
	sweetHTML = '<div class="sweet-overlay" tabIndex="-1"></div><div class="sweet-alert" tabIndex="-1"><div class="icon error"><span class="x-mark"><span class="line left"></span><span class="line right"></span></span></div><div class="icon warning"> <span class="body"></span> <span class="dot"></span> </div> <div class="icon info"></div> <div class="icon success"> <span class="line tip"></span> <span class="line long"></span> <div class="placeholder"></div> <div class="fix"></div> </div> <div class="icon custom"></div> <h2>Title</h2><p>Text</p><button class="cancel" tabIndex="2">Cancel</button><button class="confirm" tabIndex="1">OK</button></div>'
	sweetWrap = document.createElement('div')
	sweetWrap.innerHTML = sweetHTML;
	document.body.appendChild(sweetWrap);


#
# initializeDeleteLinks
# initializes the tags classed with '.delete_link' to verify deleting an issue
#
@initializeDeleteLinks = () ->
	$('.delete_link').on 'click', (e) ->
		e.preventDefault()
		$elem = $(this)
		$elem.hide()
		$('.sweet-overlay').show()

		swal
			title: "Er du sikker?",
			html: true,
			text: "Hvis du accepterer slettes posten <b>" + $(this).data('name') + "</b> permanent, og du vil ikke kunne hente den frem igen!",
			type: "warning",
			showCancelButton: true,
			confirmButtonColor: "#DD6B55",
			confirmButtonText: "Ja, slet den!",
			cancelButtonText: "Nej - jeg har fortrudt!"
			closeOnConfirm: false,
			# closeOnCancel: true,
			(confirmed) ->
				if !confirmed
					$elem.show()
					try
					  swal.close()
					catch error
					  $('.sweet-overlay').hide()
					  $('.sweet-alert').hide()
					# swal "Ok!", "Posten blev ikke slettet - du valgte at fortryde.", "success"
				else
				  deletePost($elem)
