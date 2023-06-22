class CreateGroupMembers < ActiveRecord::Migration[6.1]
  def change
    create_table :group_members do |t|
      t.references :group_memberable, polymorphic: true, null: false
      t.references :group, null: false

      t.timestamps
    end
  end
end
