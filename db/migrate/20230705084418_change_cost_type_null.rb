class ChangeCostTypeNull < ActiveRecord::Migration[6.1]
  def change
    change_column_null :costs, :type, false
  end
end
