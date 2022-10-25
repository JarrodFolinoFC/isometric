# frozen_string_literal: true

Isometric::Config.instance.app_config do
  name 'app-name'
  version File.open("#{__dir__}/version.txt").read
end
