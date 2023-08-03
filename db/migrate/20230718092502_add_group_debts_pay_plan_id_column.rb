class AddGroupDebtsPayPlanIdColumn < ActiveRecord::Migration[6.1]
  def change
    add_belongs_to :debt_steps, :group_debts_pay_plan, index: true, foreign_key: true
  end
end
