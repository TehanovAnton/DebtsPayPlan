# frozen_string_literal: true

class Debt < ApplicationRecord
  belongs_to :cost
  has_one :user,
          through: :cost,
          source: :costable,
          source_type: 'User'
end
