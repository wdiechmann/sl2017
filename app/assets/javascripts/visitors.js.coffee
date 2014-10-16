#
# 3..padLeft() => '03' 
# 3..padLeft(100,'-') => '--3' 
Number.prototype.padLeft = (base,chr) ->
	len = (String(base || 10).length - String(this).length)+1
	if len > 0
		return new Array(len).join(chr || '0')+this 
	else
		return this
		
timeIsNow = () ->
	d = new Date
	$('span.time').html d.getHours().padLeft() + ':' + d.getMinutes().padLeft()
	setTimeout( timeIsNow, 750)

timeIsNow()
