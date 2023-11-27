# frozen_string_literal: true

module Api
  module V1
    class UserAuthsController < Api::V1::BaseController
      before_action :authorize_admin!
      before_action :set_user_auth, only: :destroy

      # POST : /api/v1/user_auths
      def index
        customers = if params[:query].present?
                      UserAuth.where('id LIKE :query or phone LIKE :query or email LIKE :query', query: "%#{params[:query]}%")
                    else
                      UserAuth.momosecure_customers
                    end
        customers = customers.where.not(user_type: 'Admin')
        customers = optional_paginate(customers.order(id: :desc))

        if params[:page].present?
          render_success_paginated(customers, UserAuthSerializer, admin: @current_user.admin?)
        else
          render_success('success', customers, UserAuthSerializer, admin: @current_user.admin?)
        end
      end

      # DELETE : /api/v1/user_auths/:id
      def destroy
        @user.destroy
        render_success('success', @user.as_json(admin: @current_user.admin?))
      end

      # POST : /api/v1/user_auths/create_admin
      def create_admin
        return render_error('Please provide a name for the mrsool admin') if admin_params[:name].blank?

        user = UserAuth.new(admin_params.except(:name))
        user.user = Admin.new(name: admin_params[:name])

        if user.save
          render_success('success', user.as_json)
        else
          render_error(user.errors.full_messages.join(', '))
        end
      end

      private

      def admin_params
        params.require(:admin).permit(:name, :email, :phone, :login_type)
      end

      def set_user_auth
        @user = UserAuth.find(params[:id])
      end
    end
  end
end
