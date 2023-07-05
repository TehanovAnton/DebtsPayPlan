class AddTypeFieldToGroupMember < ActiveRecord::Migration[6.1]
  def change
    add_column :group_members, :type, :string, null: false, default: 'GroupMember'
  end
end
