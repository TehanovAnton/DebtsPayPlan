class AddDebtStepPayValue < ActiveRecord::Migration[6.1]
  def change
    add_column :debt_steps, :pay_value, :float, null: false
  end
end
