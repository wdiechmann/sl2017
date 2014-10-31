#
# 3..padLeft() => '03' 
# 3..padLeft(100,'-') => '--3' 
Number.prototype.padLeft = (base,chr) ->
	len = (String(base || 10).length - String(this).length)+1
	if len > 0
		return new Array(len).join(chr || '0')+this 
	else
		return this


initializeSweetAlert = () ->
	sweetHTML = '<div class="sweet-overlay" tabIndex="-1"></div><div class="sweet-alert" tabIndex="-1"><div class="icon error"><span class="x-mark"><span class="line left"></span><span class="line right"></span></span></div><div class="icon warning"> <span class="body"></span> <span class="dot"></span> </div> <div class="icon info"></div> <div class="icon success"> <span class="line tip"></span> <span class="line long"></span> <div class="placeholder"></div> <div class="fix"></div> </div> <div class="icon custom"></div> <h2>Title</h2><p>Text</p><button class="cancel" tabIndex="2">Cancel</button><button class="confirm" tabIndex="1">OK</button></div>'
	sweetWrap = document.createElement('div')
	sweetWrap.innerHTML = sweetHTML;
	document.body.appendChild(sweetWrap);

@Employee =
  
  log: (msg) ->
    console.log msg

  attachEvent: () ->
  	$('#employees').on "click", (e) ->
  		elem = $(e.target)[0]
  		if $(elem).hasClass('employee')
  			employee_id = elem.id.replace /.*\_/, ''
  			url = 'employees/' + employee_id + '/last_seen?at='
  			time_id = 'p#employee_id_time_' + employee_id
  			d = new Date
  			# dformat = [(d.getMonth()+1).padLeft(), d.getDate().padLeft(), d.getFullYear()].join('/') +' ' + [d.getHours().padLeft(), d.getMinutes().padLeft(), d.getSeconds().padLeft()].join(':') #=> dformat => '05/17/2012 10:52:21'
  			ddate = ([d.getDate().padLeft(), (d.getMonth()+1).padLeft(), d.getFullYear()].join('/'))
  			dtime = ([d.getHours().padLeft(), d.getMinutes().padLeft()].join(':'))
  			$(time_id).html('<span title="'+ddate+'">' + dtime + '</span>')
  			url = window.location.href + url + ddate + ' ' + dtime
  			jqhxr = $.get url
  			.done ->
          $(elem).addClass('btn-success')
          # swal
          #             title: 'Hurrahh!',
          #             text: 'Din ankomst er blevet registreret!',
          #             type: 'success',
          #             confirmButtonColor: "#0f9d58"
  			.fail ->
  				swal '#€%&%/§$', 'Der er ingen forbindelse til serveren - kontakt ALCO på tlf 9791 1470! Din ankomst er desværre ikke blevet registreret :(', 'error'
	
  setEmployees: (data) ->
    $('#employees').html data

  reloadEmployees: () ->
  	jqhxr = $.ajax 
  		url: '/employees.js',
  		dataType: 'html'			
  	.done (data,textStatus,jqHXR) ->
  		$.when Employee.setEmployees(data)
  		.done () ->
        if $('#employees').size() > 0
          Employee.attachEvent()
          if $('.sweet-alert').size() < 1
            initializeSweetAlert()
          setTimeout Employee.reloadEmployees, (1000 * 60 * 5)  # hver 5 minutter
    

    	.fail (jqHXR,textStatus,errorThrown) ->
    		$('#employees').html('')
		
  timeIsNow: () ->
  	d = new Date
  	$('span.time').html d.getHours().padLeft() + ':' + d.getMinutes().padLeft()
  	setTimeout( Employee.timeIsNow, 750)


