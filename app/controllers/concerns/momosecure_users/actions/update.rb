# frozen_string_literal: true

module MomosecureUsers
  module Actions
    module Update
      include Helper

      def update
        render_unauthorized('Not Authorized.') unless profile_owner?

        ActiveRecord::Base.transaction do
          user.update!(user_params)
          render_success('Successfully updated', user_auth.reload, UserAuthSerializer)
        end
      end
    end
  end
end
