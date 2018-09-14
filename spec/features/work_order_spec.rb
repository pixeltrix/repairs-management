require 'rails_helper'

RSpec.describe 'Work order' do
  include Helpers::Authentication
  include Helpers::HackneyRepairsRequestStubs

  let(:property_reference1) { '00014665' }
  let(:property_reference2) { '00024665' }
  let(:property_hierarchy_response) do
    [
      {
        propertyReference: property_reference1,
        levelCode: '3',
        description: 'Block',
        majorReference: '00078632',
        address: '37-45 ODD Shrubland Road',
        postCode: 'E8 4NL'
      },
      {
        propertyReference: property_reference2,
        levelCode: '2',
        description: 'Estate',
        majorReference: '00087086',
        address: 'Shrubland Estate  Shrubland Road',
        postCode: 'E8 4NL'
      }
    ]
  end

  before { sign_in }

  scenario 'Search for a work order by reference' do
    fill_in 'Search by work order reference or postcode', with: ''
    click_on 'Search'

    expect(page).to have_content 'Please provide a reference or address'

    stub_hackney_repairs_work_orders(reference: '00000000', status: 404)

    fill_in 'Search by work order reference or postcode', with: '00000000'
    click_on 'Search'

    expect(page).to have_content 'Could not find a work order with reference 00000000'

    stub_hackney_repairs_work_orders
    stub_hackney_repairs_repair_requests
    stub_hackney_repairs_properties
    stub_hackney_repairs_work_order_notes
    stub_hackney_repairs_work_order_appointments
    stub_hackney_repairs_work_order_latest_appointments
    stub_hackney_work_orders_for_property(reference: property_reference1, body: [
      work_order_response_payload("workOrderReference" => "1234", "problemDescription" => "Problem 1"),
      work_order_response_payload("workOrderReference" => "4321", "problemDescription" => "Problem 2"),
    ])
    stub_hackney_work_orders_for_property(reference: property_reference2)
    stub_hackney_property_hierarchy(body: property_hierarchy_response)

    fill_in 'Search by work order reference or postcode', with: '01551932'
    click_on 'Search'

    expect(page).to have_content 'Works order: 01551932'
    expect(page).to have_content 'Servitor ref: 10162765'
    expect(page).to have_content 'TEST problem'

    expect(page).to have_content "12 Banister House Homerton High Street E9 6BH"

    expect(page).to have_content "MR SULEYMAN ERBAS 2:10pm, 29 May 2018"
    expect(page).to have_content '02012341234'
    expect(page).to have_content 's.erbas@example.com'

    expect(page).to have_content "Appointment: Completed 8:00am to 4:15pm, 31 May 2018"

    expect(page).to have_content 'Priority: Standard'
    expect(page).to have_content 'Work order: In Progress'
    expect(page).to have_content 'Data source: DRS'

    expect(page).to have_content 'Target date: 27 Jun 2018, 2:09pm'

    expect(page).to have_content 'Notes'
    within(find('h2', text: 'Notes').find('~ ul')) do
      expect(all('li').map(&:text)).to eq([
        "11:32am, 2 September 2018 by Servitor\nFurther works required; Tiler required to renew splash back and reseal bath",
        "10:12am, 23 August 2018 by MOSHEA\nTenant called to confirm appointment",
      ])
    end

    expect(page).to have_content 'Problem 1'
    expect(page).to have_content 'Problem 2'
    expect(page).to have_link("1234", href: work_order_path("1234"))
    expect(page).to have_link("4321", href: work_order_path("4321"))
  end

  scenario 'No notes are returned' do # TODO: remove when the api in sandbox is deployed
    stub_hackney_repairs_work_orders
    stub_hackney_repairs_repair_requests
    stub_hackney_repairs_properties
    stub_hackney_repairs_work_order_notes(
      body: work_order_note_response_payload__no_notes
    )
    stub_hackney_repairs_work_order_appointments
    stub_hackney_repairs_work_order_latest_appointments
    stub_hackney_work_orders_for_property

    stub_hackney_work_orders_for_property(reference: property_reference1)
    stub_hackney_work_orders_for_property(reference: property_reference2)
    stub_hackney_property_hierarchy(body: property_hierarchy_response)

    visit work_order_path('01551932')
    expect(page).to have_content 'There are no notes for this work order.'
  end

  scenario 'No notes are returned' do # TODO: remove when the api in sandbox is deployed
    stub_hackney_repairs_work_orders
    stub_hackney_repairs_repair_requests
    stub_hackney_repairs_properties
    stub_hackney_repairs_work_order_notes(
      body: {
        "developerMessage" => "Exception of type 'HackneyRepairs.Actions.RepairsServiceException' was thrown.",
        "userMessage" => "We had some problems processing your request"
      },
      status: 500
    )
    stub_hackney_repairs_work_order_appointments
    stub_hackney_repairs_work_order_latest_appointments
    stub_hackney_work_orders_for_property

    stub_hackney_work_orders_for_property(reference: property_reference1)
    stub_hackney_work_orders_for_property(reference: property_reference2)
    stub_hackney_property_hierarchy(body: property_hierarchy_response)

    visit work_order_path('01551932')
    expect(page).to have_content 'There are no notes for this work order.'
  end

  scenario 'No appointments are booked' do
    stub_hackney_repairs_work_orders
    stub_hackney_repairs_repair_requests
    stub_hackney_repairs_properties
    stub_hackney_repairs_work_order_notes
    stub_hackney_repairs_work_order_appointments(
      body: work_order_appointment_response_payload__no_appointments
    )
    stub_hackney_repairs_work_order_latest_appointments(
      body: {
        "developerMessage" => "Exception of type 'HackneyRepairs.Actions.MissingAppointmentsException' was thrown.",
        "userMessage" => "Cannot find appointments for the work order reference"
      },
      status: 404
    )
    stub_hackney_work_orders_for_property

    stub_hackney_work_orders_for_property(reference: property_reference1)
    stub_hackney_work_orders_for_property(reference: property_reference2)
    stub_hackney_property_hierarchy(body: property_hierarchy_response)

    visit work_order_path('01551932')

    expect(page).to have_content 'There are no booked appointments.'
  end

  scenario 'No appointments are booked' do # TODO: remove when the api returns [] in this case
    stub_hackney_repairs_work_orders
    stub_hackney_repairs_repair_requests
    stub_hackney_repairs_properties
    stub_hackney_repairs_work_order_notes
    stub_hackney_repairs_work_order_appointments(
      body: {
        "developerMessage" => "Exception of type 'HackneyRepairs.Actions.MissingAppointmentsException' was thrown.",
        "userMessage" => "Cannot find appointments for the work order reference"
      },
      status: 404
    )
    stub_hackney_repairs_work_order_latest_appointments(
      body: {
        "developerMessage" => "Exception of type 'HackneyRepairs.Actions.MissingAppointmentsException' was thrown.",
        "userMessage" => "Cannot find appointments for the work order reference"
      },
      status: 404
    )
    stub_hackney_work_orders_for_property

    stub_hackney_work_orders_for_property(reference: property_reference1)
    stub_hackney_work_orders_for_property(reference: property_reference2)
    stub_hackney_property_hierarchy(body: property_hierarchy_response)

    visit work_order_path('01551932')

    expect(page).to have_content 'There are no booked appointments.'
  end

  scenario 'Filtering the repairs history by trade related to the property', js: true do
    stub_hackney_repairs_work_orders
    stub_hackney_repairs_repair_requests
    stub_hackney_repairs_properties
    stub_hackney_repairs_work_order_notes
    stub_hackney_repairs_work_order_appointments
    stub_hackney_repairs_work_order_latest_appointments
    stub_hackney_work_orders_for_property
    stub_hackney_work_orders_for_property(reference: property_reference1)
    stub_hackney_work_orders_for_property(reference: property_reference2)
    stub_hackney_property_hierarchy(body: property_hierarchy_response)

    visit work_order_path('01551932')

    within('#repair-history-tab table') do
      expect(page).to have_selector 'td', text: 'Electrical', count: 1
      expect(page).to have_selector 'td', text: 'Domestic gas: servicing', count: 1
      expect(page).to have_selector 'td', text: 'Plumbing', count: 2
    end

    find('label', text: 'Plumbing').click

    within('#repair-history-tab table') do
      expect(page).to have_selector 'td', text: 'Electrical', count: 0
      expect(page).to have_selector 'td', text: 'Domestic gas: servicing', count: 0
      expect(page).to have_selector 'td', text: 'Plumbing', count: 2
    end

    find('label', text: 'Electrical').click

    within('#repair-history-tab table') do
      expect(page).to have_selector 'td', text: 'Electrical', count: 1
      expect(page).to have_selector 'td', text: 'Domestic gas: servicing', count: 0
      expect(page).to have_selector 'td', text: 'Plumbing', count: 2
    end

    find('label', text: 'Electrical').click

    within('#repair-history-tab table') do
      expect(page).to have_selector 'td', text: 'Electrical', count: 0
      expect(page).to have_selector 'td', text: 'Domestic gas: servicing', count: 0
      expect(page).to have_selector 'td', text: 'Plumbing', count: 2
    end

    find('label', text: 'Plumbing').click

    within('#repair-history-tab table') do
      expect(page).to have_selector 'td', text: 'Electrical', count: 1
      expect(page).to have_selector 'td', text: 'Domestic gas: servicing', count: 1
      expect(page).to have_selector 'td', text: 'Plumbing', count: 2
    end
  end
end
