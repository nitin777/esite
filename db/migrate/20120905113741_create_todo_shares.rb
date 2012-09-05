class CreateTodoShares < ActiveRecord::Migration
  def change
    create_table :todo_shares do |t|
      t.integer :user_id
      t.integer :share_user_id

      t.timestamps
    end
  end
end
