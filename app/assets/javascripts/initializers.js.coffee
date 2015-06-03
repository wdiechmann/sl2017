#
# pageOnLoad
# calls initializers
#
@pageOnLoad = () ->

	initializeSweetAlert()
	unless $('.sweet-alert')
		alert "fejl"

	#
	# Initialize the 'hamburger'
	#
	$(".button-collapse").sideNav();

	#
	# Initialize the parallax'es
	#
	$('.parallax').parallax();

	#
	# Initialize modals
	#
	$('.modal-trigger').leanModal();

	#
	# Initialize collapsible (uncomment the line below if you use the dropdown variation)
	#
	$('.collapsible').collapsible
		accordion : true                  # A setting that changes the collapsible behavior to expandable instead of the default accordion style

	#
	# Initialize SELECT's
	#
	$('select').material_select();

	#
	# Initialize INPUT TYPE='DATE'
	#
	#   %input.datepicker{ type:"date" }
	#
	$('.datepicker').pickadate
		selectMonths: true, # Creates a dropdown to control month
		selectYears: 15     # Creates a dropdown of 15 years to control year

	#
	# Prepare delete_link's for acting on clicks to delete posts
	#
	initializeDeleteLinks()

	#
	# Prepare close-notice's for acting on clicks to remove div
	#
	$('.message_container').delegate 'a.close-notice', 'click', () ->
		$(this).closest('.alert').remove()

	#	here to test whether pageOnLoad runs - -
	# swal( 'Super!', 'Du er en knaldperle', 'success')


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


@userSignIn = () ->
	$('.user_sign_in').on 'click', (event) ->
		window.location.href = '/users/sign_in'

@newMessage = () ->
	request = null
	$('button.new_message').on 'click', (event) =>
		# abort any pending request
		event.preventDefault()
		if request
			request.abort()

		# setup some local variables
		$form = $('#new_message')
		# let's select and cache all the fields
		$inputs = $form.find "input, select, button, textarea"

		# serialize the data in the form
		serializedData = $form.serialize()

		# let's disable the inputs for the duration of the ajax request
		# Note: we disable elements AFTER the form data has been serialized.
		# Disabled form elements will not be serialized.
		$inputs.prop("disabled", true)

		# fire off the request to /form.php
		request = $.ajax
			url: '/messages.js',
			type: "post",
			data: serializedData

		# callback handler that will be called on success
		request.done (response, textStatus, jqXHR) ->
			# log a message to the console
			swal "Tak!", "Vi har modtaget din besked - og sendt dig en kopi pr email :)", 'success'

		# callback handler that will be called on failure
		request.fail (jqXHR, textStatus, errorThrown) ->
			# log the error to the console
			swal "ØV!", "Noget er gået galt \n Fejlen: " + jqXHR.responseText + ' ' + errorThrown, 'error'

		# callback handler that will be called regardless
		# if the request failed or succeeded
		request.always () ->
			#reenable the inputs
			$inputs.prop "disabled", false

		# prevent default posting of form
		event.preventDefault()

@jobberRegistration = () ->
	request = null
	$('button.jobber-registration').on 'click', (event) =>
		# abort any pending request
		event.preventDefault()
		if request
			request.abort()

		# setup some local variables
		$form = $('#new_jobber')
		# let's select and cache all the fields
		$inputs = $form.find "input, select, button, textarea"

		# serialize the data in the form
		serializedData = $form.serialize()

		# let's disable the inputs for the duration of the ajax request
		# Note: we disable elements AFTER the form data has been serialized.
		# Disabled form elements will not be serialized.
		$inputs.prop("disabled", true)

		# fire off the request to /form.php
		request = $.ajax
			url: '/jobbers.js',
			type: "post",
			data: serializedData

		# callback handler that will be called on success
		request.done (response, textStatus, jqXHR) ->
			# log a message to the console
			swal "Tak!", "Vi har modtaget din tilmelding - og sendt dig en email :)", 'success'

		# callback handler that will be called on failure
		request.fail (jqXHR, textStatus, errorThrown) ->
			# log the error to the console
			swal "ØV!", "Noget er gået galt \n Fejlen: " + textStatus + ' ' + errorThrown, 'error'

		# callback handler that will be called regardless
		# if the request failed or succeeded
		request.always () ->
			#reenable the inputs
			$inputs.prop "disabled", false

		# prevent default posting of form
		event.preventDefault()
