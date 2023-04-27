City.destroy_all
City.create!(name: 'Stockholm', weather_id: 2_673_730, country: 'Sweden', latitude: 59.33459, longitude: 18.06324)
City.create!(name: 'Buenos Aires', weather_id: 3_435_910, country: 'Argentina', latitude: -34.61315,
             longitude: -58.37723)
p "Created #{City.count} cities"
