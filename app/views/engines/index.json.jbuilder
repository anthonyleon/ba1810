json.array!(@engines) do |engine|
  json.extract! engine, :id, :engine_major_variant, :engine_minor_variant, :esn, :condition, :new, :overhaul, :serviceable, :non_serviceable, :in_service, :off_service, :current_operator, :last_operator, :location, :cycles_remaining, :available_date, :sale, :lease
  json.url engine_url(engine, format: :json)
end
