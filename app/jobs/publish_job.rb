class PublishJob
  @queue= :high

  def self.perform(post_id)
    post = Post.find post_id
    post.deliver
  end

end