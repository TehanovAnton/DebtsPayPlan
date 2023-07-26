class ChangeGroupUserStepStateColumnsDefault < ActiveRecord::Migration[6.1]
  def change
    change_column_default :group_user_step_states, :cost_ids, []
    change_column_default :group_user_step_states, :cost_values, []
  end
end
