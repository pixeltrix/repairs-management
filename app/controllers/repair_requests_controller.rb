class RepairRequestsController < ApplicationController
  before_action :set_property

  def new
    @repair_request = Hackney::RepairRequest.new(
      contact_attributes: {},
      work_orders_attributes: [{}]
    )
  end

  def create
    @repair_request = Hackney::RepairRequest.new(repair_request_params)
    @repair_request.property_reference = @property.reference
    respond_to do |format|
      if @repair_request.save
        format.html { redirect_to work_order_path(@repair_request.work_orders.first.reference), notice: 'Repair raised!' }
        # TODO?
        #format.json { render :show, status: :created, location: @repair_request }
      else
        format.html { render :new }
        # TODO?
        #format.json { render json: @repair_request.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_property
    @property = Hackney::Property.find(params[:property_ref])
  end

  def repair_request_params
    params.require(:hackney_repair_request).permit([
      { contact_attributes: [:name, :telephone_number] },
      { work_orders_attributes: [:sor_code] },
      :priority,
      :description
    ])
  end
end