class Hackney::RepairRequest
  include ActiveModel::Model
  include ActiveModel::Attributes

  attr_accessor :contact
  attribute :recharge, ActiveModel::Type::Boolean.new
  attr_accessor :tasks
  attr_accessor :reference
  attr_accessor :priority
  attr_accessor :property_reference
  attr_accessor :description
  attr_accessor :created_by_email
  attr_accessor :user_login
  attr_accessor :user_name
  attr_accessor :created_at

  NULL_OBJECT = self.new(description: 'Repair info missing')

  PRIORITIES = (?A..?P).to_a + %w(P1 P2 P3) + (?Q..?Z).to_a
  RAISABLE_PRIORITIES = %w(E I K O U V N L)

  def self.find(repair_request_reference)
    response = HackneyAPI::RepairsClient.new.get_repair_request(repair_request_reference)
    build(response)
  end

  # FIXME: bad naming
  def self.build(api_attributes)
    new_from_api(api_attributes)
  end

  def self.new_from_api(api_attributes)
    new(attributes_from_api(api_attributes))
  end

  # FIXME: this is view logic and shouldn't be here
  def telephone_number
    contact&.telephone_number.blank? ? "N/A" : contact&.telephone_number
  end

  def contact_name
    contact&.name
  end

  def high_priority?
    %w(E I).include? priority
  end

  #
  # persistence
  #
  def tasks_attributes=(a)
    a = a.values if a.is_a?(Hash)
    self.tasks = a.map {|x| Hackney::Task.new(x)}
  end

  def contact_attributes=(a)
    self.contact = Hackney::Contact.new(a)
  end

  def save
    response = HackneyAPI::RepairsClient.new.post_repair_request(
      name: contact_name,
      phone: telephone_number,
      tasks: tasks || [],
      priority: priority,
      property_ref: property_reference,
      description: description.squish,
      recharge: recharge,
      created_by_email: created_by_email
    )
    self.attributes = self.class.attributes_from_api(response)
    true

  rescue HackneyAPI::RepairsClient::TimeoutError => e
    # FIXME: this is duplicated in RepairRequest
    errors.add("base", "The Hackney API timed out. Please, contact the development team.")
    false

  rescue HackneyAPI::RepairsClient::ApiError => e
    self.class.errors_from_api(e.errors).each do |key, list|
      list.each do |msg|
        errors.add(key, msg)
      end
    end
    add_nested_errors
    false
  end

  private

  #
  # read attributes from API
  #

  def self.attributes_from_api(api_attributes)
    # FIXME: is this still necessary?
    stripped = api_attributes.transform_values {|v| v.try(:strip) || v }

    {
      contact:              Hackney::Contact.build(api_attributes["contact"] || {}),
      recharge:             api_attributes["isRecharge"],
      # FIXME: naming is wrong on the API
      tasks:                api_attributes["workOrders"]&.map {|x| Hackney::Task.new_from_api(x) } || [],
      reference:            api_attributes["repairRequestReference"],
      priority:             api_attributes["priority"],
      property_reference:   api_attributes["propertyReference"],
      description:          api_attributes["problemDescription"],
      created_by_email:     api_attributes[""],
      user_login:           api_attributes["uhUserLogin"],
      user_name:            api_attributes["uhUsername"],
      created_at:           api_attributes["createdDate"]&.to_datetime,
    }
  end

  def add_nested_errors
    errors.each do |key, msg|
      case key
      when /^contact\.(.*)$/i
        contact.errors.add($1, msg)
      when /^tasks\[(\d+)\]\.(.*)$/i
        tasks[$1.to_i].errors.add($2, msg)
      end
    end
  end

  def self.errors_from_api(response)
    err = {}
    # ensure we always have an array.
    [response].flatten.each do |x|
      key = parse_json_pointer(x["source"])
      err[key] ||= []
      # try hard to get a message
      err[key] << (x["message"] || x["userMessage"] || x["developerMessage"])
    end
    err
  end

  def self.parse_json_pointer p
    case p
    when /^\/contact\/telephoneNumber/i
      "contact.telephone_number"
    when /^\/contact\/name/i
      "contact.name"
    when /^\/problemDescription/i
      "description"
    when /^\/isRecharge/i
      "recharge"
    # FIXME: this should've been named "tasks" on the API
    when /^\/(tasks|workOrders)\/(\d+)\/sorCode/i
      "tasks[#{$2.to_i}].sor_code"
    # FIXME: this should've been named "tasks" on the API
    when /^\/(tasks|workOrders)\/(\d+)\/estimatedUnits/i
      "tasks[#{$2.to_i}].estimated_units"
    else
      "base"
    end
  end
end
