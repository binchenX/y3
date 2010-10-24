class CommentsController < ApplicationController

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.create(params[:comment])

    #if user has already logined int, set the user
    if current_user
      @comment.user_id = current_user.id
    end

    redirect_to post_path(@post)
  end
end
