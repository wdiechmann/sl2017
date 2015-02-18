module ApplicationHelper
  LABELS = [ 'Gerne!', 'Jatak!', 'Yeps!', 'tjoh - ', 'jow jow!', 'Det er mig!', 'Ja da!']
  def get_random_label
    LABELS[ rand(6)]
  end

end
