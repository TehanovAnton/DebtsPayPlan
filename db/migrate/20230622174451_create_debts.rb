class CreateDebts < ActiveRecord::Migration[6.1]
  def change
    create_table :debts do |t|
      t.references :cost, index: true, null: false

      t.timestamps
    end
  end
end
