class CreateGroupDebtsPayPlans < ActiveRecord::Migration[6.1]
  def change
    create_table :group_debts_pay_plans do |t|

      t.timestamps
    end
  end
end
