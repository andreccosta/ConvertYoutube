require 'zip'

class TasksController < ApplicationController
	def new
		@tasks = Task.all
	end

	def create
		@task = Task.new(task_params)
		@task.title = @task.url
		if @task.save
			Resque.enqueue(ConvertYoutubeJob, @task.id)
			redirect_to new_task_path
		else
			redirect_to new_task_path, :alert => @task.errors.empty? ? 'Something went wrong. Try again.' : @task.errors.full_messages.to_sentence
		end
	end

	def destroy
		@task = Task.find(params[:id])
		path = "#{Rails.root}/tmp/#{@task.download_url}"
		logger.debug path
		if @task.download_url != nil && File.exist?(path)
			File.delete(path)
		end
		@task.destroy

		redirect_to new_task_path
	end

	def download
		@task = Task.find(params[:id])
	    send_file "#{Rails.root}/tmp/#{@task.download_url}"
	end

	private
		def task_params
			params.require(:task).permit(:url, :done)
		end
end
