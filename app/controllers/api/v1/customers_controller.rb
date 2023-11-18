# frozen_string_literal: true

module Api
  module V1
    class CustomersController < ApplicationController
      before_action :authenticate_request!
      before_action :authorize_admin_and_profile_owner!

      has_scope :by_name do |controller, scope, value|
        scope.by_name(value, controller.model)
      end

      include MomosecureUsers::Actions::Index
      include MomosecureUsers::Actions::Show
      include MomosecureUsers::Actions::Create
      include MomosecureUsers::Actions::Update
      include MomosecureUsers::Actions::Destroy

      private

      def admin_or_profile_owner?
        @current_user.admin? || same_as_profile_owner?
      end

      def authorize_admin_and_profile_owner!
        render_unauthorized('Not Authorized.') unless admin_or_profile_owner?
      end

      def same_as_profile_owner?
        controller_name.singularize.classify.constantize.find(params[:id]) == current_user.user
      end
    end
  end
end
