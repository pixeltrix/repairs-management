require 'rails_helper'

describe Hackney::Appointment, '.build' do
  include Helpers::HackneyRepairsRequestStubs

  it 'builds when the API response contains all fields' do
    model = described_class.build(
      "visit_prop_appointment" => "2018-05-30T08:00:00",
      "visit_prop_end" => "2018-05-30T12:00:00"
    )

    expect(model).to be_a(Hackney::Appointment)
    expect(model.visit_prop_end).to eq(DateTime.new(2018, 05, 30, 12, 00, 00))
  end

  it 'raises an error if fields are not present' do
    expect {
      described_class.build({})
    }.to raise_error(NoMethodError, "undefined method `to_datetime' for nil:NilClass")
  end
end
