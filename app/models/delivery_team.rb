class DeliveryTeam < ActiveRecord::Base
  has_paper_trail

  has_ancestry

  has_many :jobbers

  attr_accessor :responsible_jobbers

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

  def jobbers_input
    # '<div>' +
    # jobbers.map{ |j| "<span class='name'>#{j.name}</span><span class='email'>#{j.email}</span>" }.join +
    # '</div>'.html_safe
    '[' + jobbers.map{ |j| "{ \"id\": #{j.id}, \"name\": \"#{j.name}\", \"email\": \"#{j.email}\"}" }.join(",") + ']'
    # '[{ "id": 1, "name": "fisk", "email": "mom"}]'
  end


  def responsible_jobbers
    # jobbers.map{ |j| "{ id: #{j.id}, name: '#{j.name}', email: '<#{j.email}>'}" }
    # jobbers.map{ |j| "<div data-value='#{j.id}' class='item'><span class='name'>#{j.name}'</span><span class='email'><#{j.email}></span></div>" }.join()
  end

  def responsible_jobbers=val
    jobbers.delete_all
    val.split(",").each{ |j| jobbers << Jobber.find(j) }
  end


end
