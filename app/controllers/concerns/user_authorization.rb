# frozen_string_literal: true

module UserAuthorization
  def authorize_admin!
    authorize_by_user_type!('Admin')
  end

  def authorize_by_user_type!(user_type)
    render_unauthorized('Not Authorized.') if @current_user.blank? || @current_user.user_type != user_type
  end

  def authorize_user_types!(user_types)
    render_unauthorized('Not Authorized.') if @current_user.blank? || user_types.exclude?(@current_user.user_type)
  end
end
