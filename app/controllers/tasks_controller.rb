class TasksController < ApplicationController
	def new
		@task = Task.new
		@tasks = Task.all
	end

	def create
		@task = Task.new(task_params)
		if @task.save
			redirect_to new_task_path
		else
			redirect_to new_task_path, :alert => @task.errors.empty? ? 'Something went wrong. Try again.' : @task.errors.full_messages.to_sentence
		end
	end

	def destroy
		@task = Task.find(params[:id])
		@task.destroy

		redirect_to new_task_path
	end

	private
		def task_params
			params.require(:task).permit(:url, :done)
		end
end
