class AddCostBelongsToDebt < ActiveRecord::Migration[6.1]
  def change
    add_belongs_to :costs, :debt, index: true, foreign_key: true
  end
end
