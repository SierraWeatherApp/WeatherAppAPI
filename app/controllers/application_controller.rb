class ApplicationController < ActionController::API
  before_action :parse_device_id!

  attr_reader :device_id

  def parse_device_id!
    @device_id = request.headers['x-device-id']
    raise StandardError, 'device_id not found' if @device_id.blank?

    @user = User.find_by(device_id: @device_id)
    return unless @user.blank?

    create_user
  rescue StandardError => e
    response = { message: e, status: :internal_server_error }
    render json: response[:message], status: response[:status]
  end

  private

  def valid_params?(parameters = [])
    parameters.each do |param|
      raise Errors::MissingArgumentError, param unless params[param]
    end
  end

  def create_user
    city = City.find_by(weather_id: 2_673_730)
    questions = Question.all
    answers = {}
    questions.each do |question|
      answers = answers.merge({ question.label => 0 })
    end
    @user = User.create!(device_id: @device_id, cities_ids: [city.id], answers:)
  end
end
