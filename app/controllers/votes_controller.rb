class VotesController < InheritedResources::Base
  #only logined user can vote - change later 
  #before_filter :require_user
  actions :create, :destroy

  #shouldnot this be in the model????/ 
  belongs_to :post, :polymorphic => true

  def create
    a = Post.find(params[:post_id])

    @vote = a.votes.create(:user_id => current_user.id, :like => like_value)
    create! do |format|
      format.html { redirect_to parent_url }
    end
  end
#
  def destroy
     destroy! do |format|
         format.html { redirect_to parent_url }
     end
  end

  private
    def like_value
      params[:like] == "true" ? true : false
    end

    def parent
      if params[:post_id]
        @post ||= Post.find(params[:post_id])
      elsif params[:question_id]
        @question ||= Question.find(params[:question_id])
      elsif params[:answer_id]
        @answer ||= Answer.find(params[:answer_id])
      end
    end

    def parent_url
      if params[:post_id]
        post_path(@post)
      elsif params[:question_id]
        question_path(@question)
      elsif params[:answer_id]
        question_path(@answer.question)
      end
    end
end
