# frozen_string_literal: true

module MomosecureUsers
  module Actions
    module Helper
      def model
        @model ||= controller_name.classify.constantize
      end

      def user_auth
        @user_auth ||= UserAuth.includes(:user).where(user_type: model).find(params[:id])
      end

      def user
        @user = user_auth.user
      end

      def user_params
        @user_params ||= resource_params(controller_name.singularize.gsub('momosecure_', '').to_sym)
      end

      def profile_owner?
        user == @current_user.user
      end
    end
  end
end
