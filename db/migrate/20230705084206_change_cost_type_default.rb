class ChangeCostTypeDefault < ActiveRecord::Migration[6.1]
  def change
    change_column_default :costs, :type, 'Cost'
  end
end
