module Arango
  #
  # Arango ErrorDB
  #
  class ErrorDB < Arango::Error
    #
    # Create database error representation
    #
    def initialize(message:, code:, data:, error_num:, action: nil, url: nil, request:)
      @message   = message
      @code      = code
      @data      = data
      @error_num = error_num
      @action    = action
      @url       = url
      @request   = request
    end
    attr_reader :action, :code, :data, :error_num, :message, :request, :url

    #
    # convert to hash
    # @return [Hash]
    def to_h
      {
        action: @action,
        url: @url,
        request: @request,
        message: @message,
        code: @code,
        data: @data,
        errorNum: @error_num
      }.delete_if{|_,v| v.nil?}
    end
  end
end
