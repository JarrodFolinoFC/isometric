# frozen_string_literal: true

class Car
  Citation.create(:singleton, ['https://springframework.guru/gang-of-four-design-patterns/'])
  Citation.add(:singleton)
  def self.instance
    @instance ||= Car.new
  end
end
