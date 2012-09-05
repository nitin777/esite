class CreateTodos < ActiveRecord::Migration
  def change
    create_table :todos do |t|
      t.string :title
      t.text :desc
      t.string :status

      t.timestamps
    end
  end
end
