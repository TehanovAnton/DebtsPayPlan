class Change < ActiveRecord::Migration[6.1]
  def change
    change_column :costs, :cost_value, :float
  end
end
