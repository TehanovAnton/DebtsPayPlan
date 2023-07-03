class AddGroupToCost < ActiveRecord::Migration[6.1]
  def change
    add_reference :costs, :group, foreign_key: true
  end
end
