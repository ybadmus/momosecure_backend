# frozen_string_literal: true

class BaseController < ApplicationController
  include ExceptionHandler
  include JsonResponders
  include JwtToken
  include Pagination
  include UserAuthentication
  include UserAuthorization

  attr_reader :current_user, :audited_user

  skip_before_action :verify_authenticity_token
end
