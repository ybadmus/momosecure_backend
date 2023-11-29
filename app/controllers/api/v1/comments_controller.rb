# frozen_string_literal: true

module Api
  module V1
    class CommentsController < Api::V1::BaseController
      before_action :authorize_users!

      # GET : api/v1/comments
      def index
        missing_params!(:commentable_type, :commentable_id)
        comments = Comment.where(commentable_type: params[:commentable_type], commentable_id: params[:commentable_id])
        comments = filter_comments(comments, params)
        comments = optional_paginate(comments)
        render_success_paginated(comments, CommentSerializer)
      end

      # GET : api/v1/comments/:id
      # Inherited from Api::V1::BaseController
      # def show; end

      # POST : api/v1/comments
      def create
        comment = resource.comments.new(action_params.merge(user_auth: current_user))
        if comment.save
          # Send notification to the other party about new comment
          render_success('success', comment, CommentSerializer)
        else
          render_error(comment.errors.full_messages)
        end
      end

      # PUT : api/v1/comments/:id
      # Inherited from Api::V1::BaseController
      # def update; end

      # DELETE : api/v1/comments/:id
      # Inherited from Api::V1::BaseController
      # def destroy; end

      private

      def action_params
        params.permit(:content)
      end

      def authorize_users!
        # Allow only admins and the users involved in the transaction to leave comments
        authorize_user_types!(%w[Admin])
      end

      def resource
        @resource ||= if params[:id].present?
                        resource_class.find(params[:id])
                      else
                        params[:commentable_type].classify.constantize.find(params[:commentable_id])
                      end
      end

      def filter_comments(comments, params)
        return comments if params.blank?

        filtered_comments = comments
        filtered_comments = filtered_comments.where(user_auth_id: params[:user_auth_id]) if params[:user_auth_id].present?
        filtered_comments = filtered_comments.where('content LIKE :query', query: "%#{params[:query]}%") if params[:query].present?
        filtered_comments
      end
    end
  end
end
