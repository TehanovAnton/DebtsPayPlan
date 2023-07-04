class RemoveGroupCostNotNullConstraint < ActiveRecord::Migration[6.1]
  def change
    change_column_null :costs, :costable_type, true
    change_column_null :costs, :costable_id, true
  end
end
