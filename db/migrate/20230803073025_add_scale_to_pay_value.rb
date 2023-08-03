class AddScaleToPayValue < ActiveRecord::Migration[6.1]
  def change
    change_column :debt_steps, :pay_value, :decimal, scale: 2, precision: 5
  end
end
