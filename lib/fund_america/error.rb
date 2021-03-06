module FundAmerica
  class Error < StandardError
    attr_reader :parsed_response
    attr_reader :code

    # Contructor method to take response code and parsed_response
    # and give object methods in rescue - e.message and e.parsed_response
    def initialize(parsed_response, code)
      super(FundAmerica::Error.error_message(code, parsed_response))
      @parsed_response = parsed_response
      @code = code
    end

    # Method to return error message based on the response code
    def self.error_message(code, parsed_response='')
      case code
      when 401 then
        'Authentication error. Your API key is incorrect'
      when 403 then
        "Not authorized. You don't have permission to take action on a particular resource. It may not be owned by your account or it may be in a state where you action cannot be taken (such as attempting to cancel an invested investment)"
      when 404 then
        'Resource was not found'
      when 422 then
        "This usually means you are missing or have supplied invalid parameters for a request: #{parsed_response}"
      when 500 then
        err = "Internal server error. Something went wrong. This is a bug. Please report it to support immediately."
        parsed_response_details = parsed_response.match(/<dl.+\/dl>/m).to_s.split("\n").map(&:strip).join
        if parsed_response_details.empty?
          err += " Unable to retrieve details from response body."
        else
          err += " Parsed response details scraped from error page: #{parsed_response_details}"
        end
      else
        'An error occured. Please check parsed_response for details'
      end
    end

  end
end
