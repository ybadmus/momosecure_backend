# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ExceptionHandler
  include JsonResponders
  include JwtToken
  include MissingData
  include Pagination
  include UserAuthentication
  include UserAuthorization

  attr_reader :current_user, :audited_user, :admin_user

  before_action :set_sentry_context

  protected

  # Add context to Sentry to help us trace exceptions
  def set_sentry_context
    Sentry.set_tags(ip: request.headers['HTTP_CF_CONNECTING_IP'] || request.headers['HTTP_X_REAL_IP'] || request.remote_ip)
    Sentry.set_user(id: @current_user.id) if @current_user.present?
    Sentry.set_extras(params: params.to_unsafe_h)
  end

  # TODO: !!! discussion needed !!!
  #       what is the purpose of introducing ransack?
  #       ransack is for search form generation and in our case, it's overhead
  #       squeel or just writing plain queries would have np

  def build_collection(resource_class)
    result = resource_class
    result = result.ransack({}).result.distinct if search_params.present?
    result = result.page(params[:page]).per(params[:limit]) if params[:limit].present?
    result.order({ created_at: :desc })
  end
end
