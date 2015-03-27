class DeliveryTeam < ActiveRecord::Base
  has_paper_trail

  has_ancestry

  def self.ancestry_options(items)
    result = []
    items.map do |item, sub_items|
      result << [yield(item), item.id]
      #this is a recursive call:
      result += self.ancestry_options(sub_items) {|i| "#{'-' * i.depth} #{i.title}" }
    end
    result
  end


  def list_title
    self.title
  end


end
