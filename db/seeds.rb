## Clear Out Current Database
Noise.destroy_all
Perishable.destroy_all

## Add Stationary Locations
def stationary_locations(noise_type, file, decibel, seasonal)
  results = HTTParty.get("https://data.seattle.gov/resource/#{file}.json").parsed_response
  results.each do |r|
    Noise.create(
      description: r["common_name"],
      noise_type: noise_type,
      lat: r["latitude"],
      lon: r["longitude"],
      decibel: decibel,
      seasonal: seasonal
    )
    print "."
  end

  puts "\n#{noise_type} Imported"  
end

# Stationary Locations Hash
stationary = {
  "Fire Station" => { file: "znfv-apni", decibel: 0, seasonal: false },
  "School" => { file: "pmap-kbvr", decibel: 0, seasonal: true },
  "College" => { file: "qawk-qmwr", decibel: 0, seasonal: true },
  "Trolley" => { file: "4qvq-uf9z", decibel: 70, seasonal: false }
}

# Loop Through Locations
stationary.each do |k, v|
  stationary_locations(k, v[:file], v[:decibel], v[:seasonal])
end
