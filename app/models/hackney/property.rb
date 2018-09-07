class Hackney::Property
  include ActiveModel::Model
  include Hackney::Client

  attr_accessor :reference, :address, :postcode

  def self.find(property_reference)
    response = client.get_property(property_reference)
    build(response)
  end

  def self.build(attributes)
    new(
      reference: attributes['propertyReference'].strip,
      address: attributes['address'],
      postcode: attributes['postcode']
    )
  end

  def work_orders
    @_work_orders ||= Hackney::WorkOrder.for_property(reference)
  end

  def dwelling_work_orders_hierarchy
    @_dwelling_work_orders_hierarchy ||= Hackney::WorkOrders::AssociatedWithProperty.new(reference).call
  end

  def trades
    @_trades ||= work_orders.map(&:trade).uniq
  end
end
