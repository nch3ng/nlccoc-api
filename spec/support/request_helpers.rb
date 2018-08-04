module Request
  module JSONHelpers
    def json_res
      @json_response ||= JSON.parse(response.body, symbolize_names: true)
    end
  end
end