# frozen_string_literal: true

module DestroyRecord
  extend ActiveSupport::Concern

  included do
    default_scope -> { where(is_deleted: false) }
  end

  def destroy
    run_callbacks(:destroy) do
      @destroyed = update_attribute(:is_deleted, true)
      freeze
    end
  end
end
