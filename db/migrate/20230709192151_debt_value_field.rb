class DebtValueField < ActiveRecord::Migration[6.1]
  def change
    add_column :debts, :debt_value, :float, null: false
  end
end
