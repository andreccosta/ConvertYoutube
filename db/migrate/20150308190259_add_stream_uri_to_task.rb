class AddStreamUriToTask < ActiveRecord::Migration
  def change
  	add_column :tasks, :stream_uri, :string
  end
end
