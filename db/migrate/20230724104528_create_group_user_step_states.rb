class CreateGroupUserStepStates < ActiveRecord::Migration[6.1]
  def change
    create_table :group_user_step_states do |t|
      t.belongs_to :user, foreign_key:true, index: true
      t.bigint 'cost_ids', array: true
      t.float 'cost_values', array: true
      
      t.timestamps
    end

    add_index :group_user_step_states, :cost_ids, using: 'gin'
    add_index :group_user_step_states, :cost_values, using: 'gin'
  end
end
