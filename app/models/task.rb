class Task < ActiveRecord::Base
	validates :url, presence: true
	validates :done, presence: true
end
