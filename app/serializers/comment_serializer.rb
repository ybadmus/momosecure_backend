# frozen_string_literal: true

class CommentSerializer < ActiveModel::Serializer
  attributes :id, :user_auth_id, :commentable_id, :commentable_type, :commentable, :content, :created_at, :updated_at

  def commentable
    commentable_type.classify.constantize.find_by(commentable_id)
  end
end
