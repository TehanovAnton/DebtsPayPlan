module Validations
  module DebtSteps
    module Validation
      extend ActiveSupport::Concern

      included do
        validates :group_debts_pay_plan, :debter, :recipient, presence: true
      end
    end    
  end  
end

class DebtStep < ApplicationRecord
  include Validations::DebtSteps::Validation

  belongs_to :group_debts_pay_plan
  belongs_to :debter,
             class_name: 'User'
  belongs_to :recipient,
             class_name: 'User'
end
