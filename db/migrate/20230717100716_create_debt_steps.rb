class CreateDebtSteps < ActiveRecord::Migration[6.1]
  def change
    create_table :debt_steps do |t|
      t.belongs_to :debter, index: true, foreing_key: true
      t.belongs_to :recipient, index: true, foreing_key: true

      t.timestamps
    end
  end
end
