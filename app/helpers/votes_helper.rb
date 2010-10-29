module VotesHelper
  def vote_like_link(voteable)
    unless current_user
      return link_to 'Like', new_user_session_path(:return_to => request.url), :class => 'like-icon'
    end

    vote = voteable.vote current_user

    #Let's make the logical simple
    #if the user has already vote,  no matter it is up or donw, he can not vote again
    
    if vote
      if vote.like? #alraedy voted like ,can not vote again
        link_to 'Like', "javascript:alert('You have already voted. Thanks.');", :class => 'like-icon active'
      else #cancel the vote
        button_to 'Like', polymorphic_path([voteable, vote]), :method => :delete, :class => 'like-icon'
      end
    else  #user has not voted , vote like
      button_to 'Like', polymorphic_path([voteable, :votes], :like => true), :class => 'like-icon'
    end
  end
  
  def vote_dislike_link(voteable)
    unless current_user
      return link_to 'Disike', new_user_session_path(:return_to => request.url), :class => 'dislike-icon'
    end
    vote = voteable.vote current_user
    if vote
      if vote.like?
        button_to 'Dislike', polymorphic_path([voteable, vote]), :method => :delete, :class => 'dislike-icon'
      else
        link_to 'Dislike', "javascript:alert('You have voted dislike this best practices!');", :class => 'dislike-icon active'
      end
    else
      button_to 'Dislike', polymorphic_path([voteable, :votes], :like => false), :class => 'dislike-icon'
    end
  end

  def voteable_link(vote)
    if vote.voteable.is_a? Answer
      question_path(vote.voteable.question)
    else
      polymorphic_path(vote.voteable)
    end
  end
end
