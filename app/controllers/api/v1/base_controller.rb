# frozen_string_literal: true

module Api
  module V1
    class BaseController < ApplicationController
      # before_action :authenticate_request!
      # before_action :authorize_users!

      # GET : /api/v1/{resource}
      def index
        render_success('success', collection, serializer)
      end

      ## ------------------------------------------------------------ ##

      # GET : /api/v1/{resource}
      def show
        render_success('success', resource, serializer)
      end

      ## ------------------------------------------------------------ ##

      # POST : /api/v1/{resource}
      def create
        resource = resource_class.new(action_params)
        if resource.save
          render_success('success', resource, serializer)
        else
          render_error(resource.errors.full_messages)
        end
      end

      ## ------------------------------------------------------------ ##

      # PUT : /api/v1/{resource}/:id
      def update
        if resource.update(action_params)
          render_success('success', resource, serializer)
        else
          render_error(resource.errors.full_messages)
        end
      end
      ## ------------------------------------------------------------ ##

      # DELETE : /api/v1/{resource}/:id
      def destroy
        if resource.destroy
          render_success('success', resource, serializer)
        else
          render_error(resource.errors.full_messages)
        end
      end

      ## ------------------------------------------------------------ ##

      private_class_method def self.validate_params_with(validator_class, only:)
        before_action(only:) do
          validator = validator_class.new(params)
          render_error(validator.errors) unless validator.valid?
        end
      end

      private

      def collection
        @collection ||= build_collection(resource_class)
      end

      def resource_class
        @resource_class ||= controller_name.singularize.classify.constantize
      end

      def serializer
        "#{resource_class}Serializer".classify.constantize
      end

      def resource
        @resource ||= resource_class.find(params[:id])
      end

      def action_params
        raise 'Method `action_params` should be defined'
      end
    end
  end
end
