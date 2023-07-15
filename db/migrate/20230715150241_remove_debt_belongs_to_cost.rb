class RemoveDebtBelongsToCost < ActiveRecord::Migration[6.1]
  def change
    remove_reference :debts, :cost, foreign_key: false, index: true
  end
end
