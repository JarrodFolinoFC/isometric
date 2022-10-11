# frozen_string_literal: true

require 'active_record'
module Isometric
  class DbConnection
    def self.from_configuration(isometric_lookup: nil)
      config = Isometric::Config.instance[isometric_lookup]
      ActiveRecord::Base.establish_connection(
        adapter: config[:adapter],
        host: config[:host],
        username: config[:username],
        password: config[:password],
        database: config[:database]
      )
    end

    def self.from_convention
      from_configuration(isometric_lookup: Isometric::DEFAULT_DATABASE_KEY)
    end
  end
end
