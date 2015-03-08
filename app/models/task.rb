class Task < ActiveRecord::Base
	validates :url, presence: true
	validates_format_of :url, :with => URI::regexp(%w(http https))
	validates_format_of :url, with: /\Syoutube.com\/(watch|playlist)?\?\S+=\S/, on: :create

	before_validation(on: :create) do
		self.url = "http://#{self.url}" unless self.url[/^https?/]
	end
end
