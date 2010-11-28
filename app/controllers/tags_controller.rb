class TagsController < ApplicationController
    #show all the post with this tags
  def show

    puts params.inspect
    @tagged_posts = Post.tagged_with(params[:id]).sort_by {|post| post.created_at}
  end

end
