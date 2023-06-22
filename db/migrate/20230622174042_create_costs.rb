class CreateCosts < ActiveRecord::Migration[6.1]
  def change
    create_table :costs do |t|
      t.references :costable, polymorphic: true, null: false
      t.integer :cost_value, null: false

      t.timestamps
    end
  end
end

# t.references :costs, :costable, polymorphic: true