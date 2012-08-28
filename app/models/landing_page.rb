require 'uri_validator'

class LandingPage < ActiveRecord::Base
  belongs_to :campaign, :class_name => "Campaign::Base", :foreign_key => "campaign_id"

  validates_presence_of :title, :sub_title, :body
  validates :owner_url, :allow_nil => true, :allow_blank => true,
  :uri => { :format => /(^$)|(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix }

  has_attached_file :main_image, :styles => { :thumb => "50x50",:small => "100x100", :medium => "300>300", :landing => "600x" },
      :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
      :url => "/system/:attachment/:id/:style/:filename"

  validates_attachment_size :main_image, :less_than => 2.megabytes
  validates_attachment_content_type :main_image, :content_type => ['image/jpeg', 'image/png', 'image/gif']

  #validates_presence_of :main_image_url, :unless => "main_image_file_name.present?"
  #validates_presence_of :main_image_file_name, :unless => "main_image_url.present?"

  def main_image_url?
    main_image_source == ImageSource::URL
  end

  def main_image_file?
    main_image_source == ImageSource::File
  end

end

# == Schema Information
#
# Table name: landing_pages
#
#  id                      :integer(4)      not null, primary key
#  campaign_id             :integer(4)
#  template_id             :integer(4)
#  title                   :string(255)
#  sub_title               :string(255)
#  body                    :text
#  main_image_file_name    :string(255)
#  main_image_content_type :string(255)
#  main_image_file_size    :integer(4)
#  owner_url               :string(255)
#  created_at              :datetime
#  updated_at              :datetime
#  main_image_url          :string(255)
#  main_image_source       :string(255)
#

