class TagsController < ApplicationController
    #show all the post with this tags
  def show

    puts params.inspect
    tagged_posts = Post.tagged_with(params[:id]).sort {|a ,b| b.created_at <=> a.created_at}

    page = params[:page] || 1
    @tagged_posts = tagged_posts.paginate :page => page , :order => "created_at DESC"

  end

end
