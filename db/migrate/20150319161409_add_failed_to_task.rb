class AddFailedToTask < ActiveRecord::Migration
  def change
  	add_column :tasks, :failed, :boolean, default: false
  end
end
