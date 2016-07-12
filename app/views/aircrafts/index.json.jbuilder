json.array!(@aircrafts) do |aircraft|
  json.extract! aircraft, :id, :aircraft_type, :msn, :tail_number, :yob, :mtow, :engine_major_variant, :engine_minor_variant, :apu_model, :cabin_config, :in_service, :off_service, :current_operator, :last_operator, :location, :maintenance_status, :available_date, :sale, :lease
  json.url aircraft_url(aircraft, format: :json)
end
