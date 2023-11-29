# frozen_string_literal: true

module Api
  module V1
    class CustomersController < ApplicationController
      before_action :authenticate_request!
      before_action :authorize_admin_and_customer!

      has_scope :by_name do |controller, scope, value|
        scope.by_name(value, controller.model)
      end

      include MomosecureUsers::Actions::Index
      include MomosecureUsers::Actions::Show
      include MomosecureUsers::Actions::Create
      include MomosecureUsers::Actions::Update
      include MomosecureUsers::Actions::Destroy

      private

      def authorize_admin_and_customer!
        authorize_user_types!(%w[Admin Customer])
      end
    end
  end
end
