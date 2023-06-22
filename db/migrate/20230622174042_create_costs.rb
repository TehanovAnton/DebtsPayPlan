class CreateCosts < ActiveRecord::Migration[6.1]
  def change
    create_table :costs do |t|
      t.bigint :costable_id, null: false
      t.string :costable_type, null: false
      t.integer :cost_value, null: false

      t.timestamps
    end
  end
end
