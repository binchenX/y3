class CommentsController < ApplicationController

  def create
    @post = Post.find(params[:post_id])
    #if current_user
    @comment = @post.comments.create(params[:comment].merge(:user => current_user))

    redirect_to post_path(@post)
  end
end
