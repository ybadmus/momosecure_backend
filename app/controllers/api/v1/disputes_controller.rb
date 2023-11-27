# frozen_string_literal: true

module Api
  module V1
    class DisputesController < Api::V1::BaseController
      before_action :authorize_users!

      # GET : api/v1/disputes
      def index
        disputes = Dispute.where(user_auth_id: @current_user.id)
        disputes = filter_disputes(disputes, params)
        disputes = optional_paginate(disputes)
        render_success_paginated(disputes, DisputeSerializer)
      end

      # GET : api/v1/disputes/:id
      # Inherited from Api::V1::BaseController
      # def show; end

      # POST : api/v1/disputes
      def create
        dispute = resource.new(action_params.merge(user_auth: current_user))
        if dispute.save
          # Send notification to the other party about dispute creation
          render_success('success', dispute, DisputeSerializer)
        else
          render_error(dispute.errors.full_messages)
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
        params.permit(:category, :contact_number, :description, :transaction_id)
      end

      def authorize_users!
        # Allow only admins and parties involved in the payment transaction create disputes
        authorize_user_types!(%w[Admin])
      end

      def filter_disputes(disputes, params)
        return disputes if params.blank?

        filtered_disputes = disputes
        filtered_disputes = filter_disputes.where(category: params[:category]) if params[:category].present?
        filtered_disputes = filter_disputes.where(contact_number: params[:contact_number]) if params[:contact_number].present?
        filtered_disputes = filter_disputes.where(transaction_id: params[:transaction_id]) if params[:transaction_id].present?
        filtered_disputes = filtered_disputes.where('description LIKE :query', query: "%#{params[:query]}%") if params[:query].present?
        filtered_disputes
      end
    end
  end
end
