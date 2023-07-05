class AddCostTypeColumn < ActiveRecord::Migration[6.1]
  def change
    add_column :costs, :type, :string
  end
end
