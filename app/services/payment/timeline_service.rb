# frozen_string_literal: true

module Payment
  class TimelineService
    def initialize(payment_transaction:)
      @payment_transaction = payment_transaction
      @payment_transaction_timeline = @payment_transaction.payment_transaction_timeline
    end

    def perform
      return unless status_column_exists?
      return if @payment_transaction_timeline.blank?
      return if status_already_filled?

      @payment_transaction_timeline.update!({ status_column_name => Time.zone.now })
    end

    private

    def status_column_name
      "#{@payment_transaction.status}_at"
    end

    def status_column_exists?
      BusinessOrderTimeline.column_names.include?(status_column_name)
    end

    def status_already_filled?
      @payment_transaction_timeline.read_attribute(status_column_name).present?
    end
  end
end
