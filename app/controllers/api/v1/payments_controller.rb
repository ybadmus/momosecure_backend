# frozen_string_literal: true

module Api
  module V1
    class PaymentsController < Api::V1::BaseController
      before_action :authorize_users!
      before_action :authorize_admin_or_payment_member!, only: [:show]

      # GET : api/v1/payments
      def index
        payments = Payment::ListPaymentsService.new(user: current_user, params:).perform
        payments = payments.includes(:sender_user_auth, :receiver_user_auth)
        payments = optional_paginate(payments)
        render_success_paginated(payments, PaymentSerializer)
      end

      # GET : /api/v1/payments
      def show
        render_success('success', resource, serializer, show_disputes: true)
      end

      private

      def authorize_users!
        authorize_user_types!(%w[Admin Customer])
      end

      def admin_or_payment_member?
        current_user.admin? || resource.receiver_user_auth == current_user || resource.sender_user_auth == current_user
      end

      def authorize_admin_or_payment_member!
        render_unauthorized('Not Authorized.') unless admin_or_payment_member?
      end
    end
  end
end
