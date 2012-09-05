class AddCompletedUserIdToTodos < ActiveRecord::Migration
  def change
    add_column :todos, :completed_user_id, :integer
  end
end
