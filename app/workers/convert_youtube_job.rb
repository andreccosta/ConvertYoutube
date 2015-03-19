require 'resque/errors'
require 'viddl-rb'
require 'youtube_it'
require 'id3_tags'

class ConvertYoutubeJob
  @queue = :tasks_queue

	def self.perform(task_id)
  		task = Task.find(task_id)

  		client = YouTubeIt::Client.new

  		#Grab title
  		title = client.video_by(task.url).title
  		task.update_attribute(:title, title)

  		#Grab cover art
  		puts("Grabbing cover art");
  		thumbs = client.video_by(task.url).thumbnails
		thumbs.each {|thumb| @thumbhd = thumb.url if thumb.name == 'hqdefault'}
		cover_art_name = "#{title}.jpg"
		system("curl #{@thumbhd} > \"#{Rails.root}/tmp/#{cover_art_name}\"")

  		#Retrieving video and audio
  		puts("Grabbing video using viddl-rb");
  		puts("Executing viddl-rb #{task.url} -e -s #{Rails.root}/tmp/")
  		system("viddl-rb #{task.url} -e -s #{Rails.root}/tmp/")

  		original_file_name = ViddlRb.get_names(task.url).first.to_s
		file_name = File.basename(original_file_name,File.extname(original_file_name))
		file_name = "#{file_name}.m4a"

		#Adding title tags and cover_art
  		puts("Changing id3tags from \"#{Rails.root}/tmp/#{file_name}\"");
		tags = Id3Tags.read_tags_from("#{Rails.root}/tmp/#{file_name}")
  		puts("Setting title");
		tags[:title] = title
  		puts("Setting cover art");
		tags[:cover_art][:mime_type] = "image/jpeg"
		tags[:cover_art][:data] = File.read("#{Rails.root}/tmp/#{cover_art_name}")

  		puts("Writting id3tags");
		Id3Tags.write_tags_to("#{Rails.root}/tmp/#{file_name}", tags)
		
		#Deleting unecessary files # DANGEROUS
		puts("Removing unnecessary files")
		File.delete("tmp/#{original_file_name}")
		File.delete("tmp/#{cover_art_name}")

		puts("Updating attributes")
  		task.update_attribute(:download_url, file_name)
		task.update_attribute(:done, true)
	rescue 
		task.update_attribute(:failed, true)
		task.update_attribute(:done, true)
	end
end