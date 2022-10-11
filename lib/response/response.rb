module Isometric
  class Response
    def self.render_response(corr_id)
      { correlation_id: corr_id }
    end
  end
end