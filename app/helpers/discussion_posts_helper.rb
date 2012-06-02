require Rails.root + 'lib/chunks/engines'

module DiscussionPostsHelper
  def render_discussion_post(post)
    content = WikiContent.new(post, UrlGenerator.new(controller))
    content.render!
  end
end
