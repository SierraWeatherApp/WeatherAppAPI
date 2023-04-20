class ApplicationController < ActionController::API
  before_action :parse_device_id!

  attr_reader :device_id

  def parse_device_id!
    @device_id = request.headers['x-device-id']
    # TODO: create specific Error
    raise StandardError, 'device_id not found' if @device_id.blank?

    @user = User.find_by(device_id: @device_id)
    return unless @user.blank?

    @user = User.create(device_id: @device_id)
    City.create(city_id: 2_673_730, city_name: 'Stockholm', country: 'Sweden', latitude: 59.33459,
                longitude: 18.06324, order: 1, user_id: @user.id)
  rescue StandardError => e
    response = { message: e, status: :internal_server_error }
    render json: response[:body], status: response[:status]
  end

  private

  def valid_params?(parameters = [])
    parameters.each do |param|
      raise Errors::MissingArgumentError, param unless params[param]
    end
  end
end
