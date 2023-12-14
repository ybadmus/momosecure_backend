# frozen_string_literal: true

module Payment
  class ListPaymentsService
    def initialize(current_user:, params:)
      @current_user = current_user
      @params = params
    end

    def perform
      payments = load_payments
      filter_payments(payments)
    end

    private

    def load_payments
      case @current_user.user_type
      when 'Customer'
        Payment.where(sender_user_auth: @current_user).or(Payment.where(receiver_user_auth: @current_user))
      when 'Admin'
        payments = Payment.where.not(sender_user_auth: @current_user).or(Payment.where.not(receiver_user_auth: @current_user))
        payments = payments.where.not(status: %i[under_creation cancel_under_creation])
        payments = payments.where(disputes: { assignee_user_auth_id: @current_user.id }) if @params[:self].present?
        payments
      end
    end

    def filter_payments(payments)
      return payments if @params.blank?

      filtered_payments = payments
      filtered_payments = filtered_payments.where(status: @params[:status]) if @params[:status].present?
      filtered_payments = filtered_payments.where(status: @params[:statuses]) if @params[:statuses].present?
      filtered_payments = filtered_payments.where(receiver_phone: @params[:receiver_phone]) if @params[:receiver_phone].present?
      filtered_payments = filtered_payments.where(reference_number: @params[:reference_number]) if @params[:reference_number].present?
      filtered_payments = filtered_payments.where(sender_phone: @params[:sender_phone]) if @params[:sender_phone].present?
      filtered_payments = filtered_payments.where(id: @params[:id]) if @params[:id].present?
      filtered_payments = filtered_payments.where(id: @params[:ids]) if @params[:ids].present?
      filtered_payments = filtered_payments.where('receiver_phone LIKE :query OR sender_phone LIKE :query OR reference_number LIKE :query', query: "%#{@params[:query]}%") if @params[:query].present?
      filtered_payments = date_limit_filter(filtered_payments) if @params[:date_limit].present?
      filtered_payments = filtered_payments.where(receiver_user_auth_id: @params[:receiver_user_auth_id]) if @params[:receiver_user_auth_id].present?
      filtered_payments = filtered_payments.where(sender_user_auth_id: @params[:sender_user_auth_id]) if @params[:sender_user_auth_id].present?
      filtered_payments
    end

    def date_limit_filter(filtered_payments)
      case @params[:date_limit]
      when 'today'
        filtered_payments.where(created_at: DateTime.now.in_time_zone(time_zone).all_day)
      when 'yesterday'
        business_orders.where(created_at: (DateTime.now.in_time_zone(time_zone) - 1.day).all_day)
      when 'last_hours'
        business_orders.where(created_at: 5.hours.ago..Time.zone.now)
      end
    end
  end
end
