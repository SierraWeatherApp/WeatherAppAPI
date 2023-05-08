City.destroy_all
Question.delete_all
City.create!(name: 'Stockholm', weather_id: 2_673_730, country: 'Sweden', latitude: 59.33459, longitude: 18.06324)
City.create!(name: 'Buenos Aires', weather_id: 3_435_910, country: 'Argentina', latitude: -34.61315,
             longitude: -58.37723)
Question.create!(question: 'Do you like to wear caps?', label: :capUser)
Question.create!(question: 'Do you like to wear shorts?', label: :shortUser)
Question.create!(question: 'Do you like to wear sandals?', label: :sandalUser)
Question.create!(question: 'Are you warmer or colder dressed than the people around you?', min: -10, max: 10,
                 label: :userTemp)
Question.create!(question: 'Do you live in a hot or cold place?', min: -10, max: 10, label: :userPlace)
p "Created #{City.count} cities"
p "Created #{Question.count} questions"
