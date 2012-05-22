# -*- encoding : utf-8 -*-
require 'lib/validates_url'

class LandingPage < ActiveRecord::Base  
  belongs_to :campaign

  validates_presence_of :title, :sub_title, :body  
  validates_format_of_url :owner_url, :allow_nil => true, :allow_blank => true

  #http://railscasts.com/episodes/134-paperclip
  has_attached_file :main_image, :styles => { :thumb => "50x50",:small => "100x100", :medium => "300>300", :landing => "600x" },
    :url => "/system/:class/:attachment/:id/:style/:basename.:extension",
    :path => ":rails_root/public/system/:class/:attachment/:id/:style/:basename.:extension"

  #validates_attachment_presence :logo, :message => "debe ser elegido"
  validates_attachment_size :main_image, :less_than => 2.megabytes
  validates_attachment_content_type :main_image, :content_type => ['image/jpeg', 'image/png', 'image/gif']
  validate :main_image_url_validation

  def main_image_url_validation
      if main_image_url? && main_image_file_name.nil?
        errors.add(:main_image_url, "es invalida")
      end
  end

  def main_image_logo?
    main_image_source == ImageSource::Logo
  end

  def main_image_url?
    main_image_source == ImageSource::URL
  end

  def main_image_file?
    main_image_source == ImageSource::File
  end


end
