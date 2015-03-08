class TasksController < ApplicationController
	def new
		@task = Task.new
		@tasks = Task.all
	end

	def create
		@task = Task.new(taskparams)
		@task.save
		redirect_to new_task_path
	end

	private
		def taskparams
			params.require(:task).permit(:url)
		end
end
