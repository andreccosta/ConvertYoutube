class ChangeUrlOnTask < ActiveRecord::Migration
  def change
  	remove_column :tasks, :done
  	add_column :tasks, :done, :boolean, default: false
  end
end
