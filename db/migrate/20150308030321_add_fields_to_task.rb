class AddFieldsToTask < ActiveRecord::Migration
  def change
  	add_column :tasks, :url, :string
  	add_column :tasks, :done, :boolean
  end
end
