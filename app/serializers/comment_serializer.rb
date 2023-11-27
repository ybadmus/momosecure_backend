# frozen_string_literal: true

class CommentSerializer < ActiveModel::Serializer
  attributes :id, :user_auth_id, :commentable_id, :commentable_type, :content, :created_at, :updated_at
end
