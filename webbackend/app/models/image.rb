class Image < ActiveRecord::Base
  attr_accessible :title, :data_file_name, :data_content_type, :data_file_size, :data_updated_at
end
