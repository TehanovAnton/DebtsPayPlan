class AddScaleToCostValue < ActiveRecord::Migration[6.1]
  def change
    change_column :costs, :cost_value, :decimal, scale: 2, precision: 5
  end
end
