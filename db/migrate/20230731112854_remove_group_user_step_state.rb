class RemoveGroupUserStepState < ActiveRecord::Migration[6.1]
  def change
    drop_table :group_user_step_states
  end
end
