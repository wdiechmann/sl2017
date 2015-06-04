module MessagesHelper
  def show_message_body message
    body = message.body.dup
    if body.include? '<html'
      body = body.gsub( /[\n|\r]/, '').partition( /<body[^>]*>/)[2].partition(/<\/body.*$/)[0]
    else
      body = body[0..100]
    end
    body.html_safe
  end
end
