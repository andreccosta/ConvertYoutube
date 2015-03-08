class AddDownloadPathToTask < ActiveRecord::Migration
  def change
  	add_column :tasks, :download_url, :string
  end
end
