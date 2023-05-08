class ClothTypesService
  def change_cloth_preference(user, preferences)
    preferences.each do |preference|
      user.preferences[preference[0].to_s] = preference[1].to_i
    end
    user.save!
  end
end
