class AddPriorityToLinks < ActiveRecord::Migration
  def change
    add_column :links, :priority, :integer
  end
end
