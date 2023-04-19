module Errors
  class APIError < StandardError
    attr_accessor :code

    def initialize(code, msg = nil, _request = nil, _exception = nil)
      @code = code
      @message = if msg.present?
                   msg.is_a?(Hash) ? msg : { message: msg }
                 else
                   ERRORS[code]
                 end
      super(msg)
    end

    def render_json
      {
        json: @message,
        status: @code
      }
    end

    ERRORS = {
      400 => {
        message: 'parsing_body_error'
      },
      401 => {
        message: 'unauthorized_invalid_api_token_error'
      },
      404 => {
        message: 'not_found_error'
      },
      422 => {
        message: 'unprocessable_entity_error' # more customized message may override this
      },
      500 => {
        message: 'internal_server_error'
      }
    }.freeze
  end

  # MicroServices Response Error class
  class ServiceResponseError < StandardError
    attr_reader :object

    def initialize(object, msg = nil)
      @object = object
      super(msg)
    end
  end

  class MissingArgumentError < StandardError
    def initialize(argument)
      super
      @argument = argument
    end
  end
end
