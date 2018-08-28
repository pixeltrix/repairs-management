module Helpers
  module HackneyRepairsRequestStubs
    # GET /v1/work_orders/:reference

    def work_order_response_payload(overrides = {})
      {
        "sorCode" => "08500110",
        "trade" => "Painting & Decorating",
        "workOrderReference" => "01551932",
        "repairRequestReference" => "03209397",
        "problemDescription" => "TEST problem",
        "created" => "2018-05-29T14:10:06",
        "estimatedCost" => 4.13,
        "actualCost" => 0.0,
        "completedOn" => "1900-01-01T00:00:00",
        "dateDue" => "2018-06-27T14:09:00",
        "workOrderStatus" => "200",
        "dloStatus" => "1",
        "servitorReference" => "10162765",
        "propertyReference" => "00014665"
      }.merge(overrides)
    end

    def stub_hackney_repairs_work_orders(opts = {})
      reference = opts.fetch(:reference, '01551932')
      status = opts.fetch(:status, 200)
      body = opts.fetch(:body, work_order_response_payload)

      stub_request(:get, "https://hackneyrepairs/v1/work_orders/#{reference}")
        .to_return(status: status, body: body.to_json)
    end

    # GET /v1/repairs/:reference

    def repair_request_response_payload(overrides = {})
      {
        "repairRequestReference" => "03209397",
        "problemDescription" => "TEST problem",
        "priority" => "N",
        "propertyReference" => "00014665",
        "contact" => {
          "name" => "MR SULEYMAN ERBAS",
          "telephoneNumber" => "02012341234",
          "emailAddress" => "s.erbas@example.com"
        },
        "workOrders" => [
          {
            "workOrderReference" => "01551932",
            "sorCode" => "08500110",
            "supplierReference" => "H09"
          }
        ]
      }.deep_merge(overrides)
    end

    def stub_hackney_repairs_repair_requests(opts = {})
      reference = opts.fetch(:reference, '03209397')
      status = opts.fetch(:status, 200)
      body = opts.fetch(:body, repair_request_response_payload)

      stub_request(:get, "https://hackneyrepairs/v1/repairs/#{reference}")
        .to_return(status: status, body: body.to_json)
    end

    # GET /v1/properties/:reference

    def property_response_payload
      {
        "address" => "12 Banister House Homerton High Street",
        "postcode" => "E9 6BH",
        "propertyReference" => "00014665",
        "maintainable" => true
      }
    end

    def stub_hackney_repairs_properties(opts = {})
      reference = opts.fetch(:reference, '00014665')
      status = opts.fetch(:status, 200)
      body = opts.fetch(:body, property_response_payload)

      stub_request(:get, "https://hackneyrepairs/v1/properties/#{reference}")
        .to_return(status: status, body: body.to_json)
    end

    # GET v1/workorders/:reference/notes

    def work_order_notes_payload
      [
        {
          "text": "Tenant called to confirm appointment",
          "loggedAt": "2018-08-23T10:12:56+01:00",
          "loggedBy": "MOSHEA"
        },
        {
          "text": "Further works required; Tiler required to renew splash back and reseal bath",
          "loggedAt": "2018-09-02T11:32:14+01:00",
          "loggedBy": "Servitor"
        }
      ]
    end

    def work_order_note_response_payload__no_notes
      []
    end

    def stub_hackney_repairs_work_order_notes(opts = {})
      reference = opts.fetch(:reference, '01551932')
      status = opts.fetch(:status, 200)
      body = opts.fetch(:body, work_order_notes_payload)

      stub_request(:get, "https://hackneyrepairs/v1/work_orders/#{reference}/notes")
        .to_return(status: status, body: body.to_json)
    end

    # GET /v1/work_orders/:workOrderReference/appointments

    def work_order_appointments_response_payload
      [
        {
          "visit_sid" => 152225691,
          "visiting_sid" => 0,
          "visitor_sid" => 43468469,
          "reference_sid" => 152221260,
          "visit_appoint" => "1900-01-01T00:00:00",
          "visit_success" => false,
          "visit_carded" => false,
          "visit_comment" => "first                                             ",
          "property_sid" => 0,
          "visit_end" => "1900-01-01T00:00:00",
          "visit_slot" => false,
          "visit_prop_appointment" => "2018-05-30T08:00:00",
          "visit_prop_end" => "2018-05-30T12:00:00",
          "visit_prop_duration" => 300,
          "visit_duration" => 300,
          "hadiary_sid" => 0,
          "visiting_table" => "          ",
          "visitor_table" => "supplier  ",
          "reference_table" => "UHOrder             ",
          "visit_cat" => "   ",
          "visit_outcome" => "   ",
          "visit_outcometype" => "   ",
          "visit_reason" => "   ",
          "visit_actual" => "1900-01-01T00:00:00",
          "comp_avail" => "                                                                                                                                                                                                        ",
          "comp_display" => "                                                                                                                                                                                                        ",
          "contacttype_lrf" => "   ",
          "visit_book_cat" => 0,
          "visit_reason_except" => "   ",
          "visit_slot_type" => "   ",
          "visit_processno" => 0,
          "visit_hhref" => 0,
          "visit_class" => "   ",
          "visit_type" => "2  "
        },
        {
          "visit_sid" => 152221261,
          "visiting_sid" => 0,
          "visitor_sid" => 43468469,
          "reference_sid" => 152221260,
          "visit_appoint" => "1900-01-01T00:00:00",
          "visit_success" => false,
          "visit_carded" => false,
          "visit_comment" => "Morning",
          "property_sid" => 0,
          "visit_end" => "1900-01-01T00:00:00",
          "visit_slot" => false,
          "visit_prop_appointment" => "2018-05-29T08:00:00",
          "visit_prop_end" => "2018-05-29T12:00:00",
          "visit_prop_duration" => 240,
          "visit_duration" => 240,
          "hadiary_sid" => 0,
          "visiting_table" => "          ",
          "visitor_table" => "supplier  ",
          "reference_table" => "UHOrder             ",
          "visit_cat" => "REP",
          "visit_outcome" => "   ",
          "visit_outcometype" => "   ",
          "visit_reason" => "   ",
          "visit_actual" => "1900-01-01T00:00:00",
          "comp_avail" => "                                                                                                                                                                                                        ",
          "comp_display" => "                                                                                                                                                                                                        ",
          "contacttype_lrf" => "   ",
          "visit_book_cat" => 0,
          "visit_reason_except" => "   ",
          "visit_slot_type" => "   ",
          "visit_processno" => 0,
          "visit_hhref" => 0,
          "visit_class" => "   ",
          "visit_type" => "1  "
        }
      ]
    end

    def work_order_appointment_response_payload__out_of_target
      [
        {
          "visit_sid" => 152225691,
          "visiting_sid" => 0,
          "visitor_sid" => 43468469,
          "reference_sid" => 152221260,
          "visit_appoint" => "1900-01-01T00:00:00",
          "visit_success" => false,
          "visit_carded" => false,
          "visit_comment" => "first                                             ",
          "property_sid" => 0,
          "visit_end" => "1900-01-01T00:00:00",
          "visit_slot" => false,
          "visit_prop_appointment" => "2018-06-28T08:00:00",
          "visit_prop_end" => "2018-06-28T12:00:00",
          "visit_prop_duration" => 300,
          "visit_duration" => 300,
          "hadiary_sid" => 0,
          "visiting_table" => "          ",
          "visitor_table" => "supplier  ",
          "reference_table" => "UHOrder             ",
          "visit_cat" => "   ",
          "visit_outcome" => "   ",
          "visit_outcometype" => "   ",
          "visit_reason" => "   ",
          "visit_actual" => "1900-01-01T00:00:00",
          "comp_avail" => "                                                                                                                                                                                                        ",
          "comp_display" => "                                                                                                                                                                                                        ",
          "contacttype_lrf" => "   ",
          "visit_book_cat" => 0,
          "visit_reason_except" => "   ",
          "visit_slot_type" => "   ",
          "visit_processno" => 0,
          "visit_hhref" => 0,
          "visit_class" => "   ",
          "visit_type" => "2  "
        }
      ]
    end

    def work_order_appointment_response_payload__no_appointments
      []
    end

    def stub_hackney_repairs_work_order_appointments(opts = {})
      reference = opts.fetch(:reference, '01551932')
      status = opts.fetch(:status, 200)
      body = opts.fetch(:body, work_order_appointments_response_payload)

      stub_request(:get, "https://hackneyrepairs/v1/work_orders/#{reference}/appointments")
        .to_return(status: status, body: body.to_json)
    end

    def stub_hackney_work_orders_for_property(reference: '00014665', status: 200,
                                              body: [work_order_response_payload])
      stub_request(:get, "https://hackneyrepairs/v1/work_orders?propertyReference=#{reference}")
        .to_return(status: status, body: body.to_json)
    end

    def property_hierarchy_response_body
      [
        {
          propertyReference: '00014665',
          levelCode: '3',
          description: 'Block',
          majorReference: '00078632',
          address: '37-45 ODD Shrubland Road',
          postCode: 'E8 4NL'
        },
        {
          propertyReference: '00078632',
          levelCode: '2',
          description: 'Estate',
          majorReference: '00087086',
          address: 'Shrubland Estate  Shrubland Road',
          postCode: 'E8 4NL'
        }
      ]
    end

    def stub_hackney_property_hierarchy(opts = {})
      reference = opts.fetch(:reference, '00014665')
      status = opts.fetch(:status, 200)
      body = opts.fetch(:body, property_hierarchy_response_body)

      stub_request(:get, "https://hackneyrepairs/v1/properties/#{reference}/hierarchy")
        .to_return(status: status, body: body.to_json)
    end
  end
end
