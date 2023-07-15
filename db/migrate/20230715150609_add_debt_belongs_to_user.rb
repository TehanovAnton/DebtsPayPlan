class AddDebtBelongsToUser < ActiveRecord::Migration[6.1]
  def change
    add_belongs_to :debts, :user, foreign_key: true, index: true
  end
end
