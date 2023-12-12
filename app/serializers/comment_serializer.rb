# frozen_string_literal: true

# == Schema Information
#
# Table name: comments
#
#  id               :bigint           not null, primary key
#  commentable_type :string(255)
#  content          :text(65535)
#  is_deleted       :boolean          default(FALSE), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  commentable_id   :bigint
#  user_auth_id     :bigint           not null
#
# Indexes
#
#  index_comments_on_commentable   (commentable_type,commentable_id)
#  index_comments_on_user_auth_id  (user_auth_id)
#
class CommentSerializer < ActiveModel::Serializer
  attributes :id, :user_auth_id, :commentable_id, :commentable_type, :commentable, :content, :created_by, :created_at, :updated_at

  def commentable
    commentable_type.classify.constantize.find_by(commentable_id).as_json
  end

  def created_by
    ActiveModelSerializers::SerializableResource.new(object.user_auth, serializer: UserAuthSerializer)
  end
end
