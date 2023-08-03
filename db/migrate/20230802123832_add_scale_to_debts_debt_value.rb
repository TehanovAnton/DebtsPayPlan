class AddScaleToDebtsDebtValue < ActiveRecord::Migration[6.1]
  def change
    change_column :debts, :debt_value, :decimal, scale: 2, precision: 5
  end
end
