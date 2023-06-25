# frozen_string_literal: true

class Cost < ApplicationRecord
  has_one :debt, dependent: :destroy
  belongs_to :costable,
             polymorphic: true
end
