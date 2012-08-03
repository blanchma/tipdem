class Product < ActiveRecord::Base
  #attr_accessible :name, :description, :legal, :picture_file_name,
  #:picture_content_type, :picture_file_size

  has_many :rewards
  has_many :campaigns, through: :rewards

  validate :name, :description, :presence => true
end
