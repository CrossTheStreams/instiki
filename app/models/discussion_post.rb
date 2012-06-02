class DiscussionPost < ActiveRecord::Base
  belongs_to :web

  def page
    @page ||= OpenStruct.new(:web => web)
  end
end
