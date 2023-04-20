class ApplicationController < ActionController::API
  private

  def valid_params?(parameters = [])
    parameters.each do |param|
      raise Errors::MissingArgumentError, param unless params[param]
    end
  end
end
