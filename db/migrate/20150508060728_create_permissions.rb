class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.integer :user_id
      t.integer :project_id
      t.integer :level

      t.timestamps null: false
    end
  end
end
